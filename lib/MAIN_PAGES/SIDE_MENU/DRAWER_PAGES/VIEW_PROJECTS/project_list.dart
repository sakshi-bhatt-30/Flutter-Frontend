import 'dart:async'; // Import this for Timer
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import '/MODALS/show_project_modal.dart';
import '/SERVICES/DELETE SERVICES/delete_project_service.dart';
import '/SERVICES/GET SERVICES/show_project_service.dart';
import '/UTILITIES/secure_storage_contents.dart';
import 'add_new_project.dart';
import 'project_details.dart';
import 'update_project.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final Logger _logger = Logger('UserService');
  final Color customTeal = Color(0xFF61A3FA);
  final _storage = FlutterSecureStorage();
  List<Organization> organizations = [];
  bool isLoading = true;
  bool isAdmin = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadOrganizations();
    _checkAdminStatus();
  }

  // Method to load organizations
  Future<void> _loadOrganizations() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      final service = OrganizationService();
      final List<Organization> fetchedOrganizations =
          await service.fetchOrganizations();
      _logger.info('Fetched Organizations: $fetchedOrganizations');
      if (mounted) {
        setState(() {
          organizations = fetchedOrganizations;
          isLoading = false;
        });
      }
    } catch (e) {
      _logger.info('Error loading organizations: $e');
      if (mounted) {
        setState(() {
          organizations = [];
          isLoading = false;
        });
      }
    }
  }

  Future<void> _checkAdminStatus() async {
    final userOrgData = UserOrgData();
    String? adminStatus = await userOrgData.getAdminStatus();
    setState(() {
      isAdmin = adminStatus == 'true';
    });
  }

  Future<void> _saveProjectIdentiForUrl(String projectIdentiForUrl) async {
    try {
      await _storage.write(
          key: 'projectIdentiForUrl', value: projectIdentiForUrl);
      _logger.info('Project Identifier saved successfully.');
    } catch (e) {
      _logger.info('Error saving project identifier: $e');
    }
  }

  Future<void> _deleteProject(String projectId) async {
    try {
      final deleteService = DeleteService();
      // Save the project ID in secure storage as expected by DeleteService
      await _saveProjectIdentiForUrl(projectId);
      // Call the delete function
      final success = await deleteService.deleteProject();

      if (success) {
        // Optionally refresh the project list after successful deletion
        await _loadOrganizations();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project deleted successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete the project.')),
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during the deletion process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showDeleteDialog(String projectId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Project'),
          content: const Text('Are you sure you want to delete this project?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteProject(projectId); // Delete the project
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Projects',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _loadOrganizations,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : organizations.isEmpty
                ? const Center(child: Text('No projects found.'))
                : ListView.builder(
                    itemCount: organizations.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          _showDeleteDialog(
                              organizations[index].projectId.toString());
                        },
                        onTap: () async {
                          await _saveProjectIdentiForUrl(
                              organizations[index].projectId.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsPage(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.folder_copy_outlined,
                                  color: Colors.black),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  organizations[index].projectName ?? 'unnamed',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal.shade900,
                                  ),
                                ),
                              ),
                              if (isAdmin)
                                PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateProjectPage(
                                            onProjectUpdated:
                                                _loadOrganizations,
                                            initialName: organizations[index]
                                                .projectName
                                                .toString(),
                                            initialDescription:
                                                organizations[index]
                                                    .projectDescription
                                                    .toString(),
                                            projectId: organizations[index]
                                                .projectId
                                                .toString(),
                                          ),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      await _showDeleteDialog(
                                          organizations[index]
                                              .projectId
                                              .toString());
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit Project'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete Project'),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewProjectPage(
                      onProjectAdded: _loadOrganizations,
                    ),
                  ),
                );
              },
              backgroundColor: Colors.black54,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
