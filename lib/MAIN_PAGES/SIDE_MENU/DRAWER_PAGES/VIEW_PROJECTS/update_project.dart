import 'package:flutter/material.dart';
import '/SERVICES/PUT SERVICES/update_project_service.dart'; // Import your service

class UpdateProjectPage extends StatefulWidget {
  final VoidCallback onProjectUpdated; // Callback to refresh the project list
  final String initialName; // Current project name
  final String initialDescription; // Current project description
  final String projectId; // Current project description

  UpdateProjectPage(
      {required this.onProjectUpdated,
      required this.initialName,
      required this.initialDescription,
      required this.projectId});

  @override
  _UpdateProjectPageState createState() => _UpdateProjectPageState();
}

class _UpdateProjectPageState extends State<UpdateProjectPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current project data
    _nameController = TextEditingController(text: widget.initialName);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
  }

  Future<void> _submitUpdate() async {
    final String updatedName = _nameController.text;
    final String updatedDescription = _descriptionController.text;

    if (updatedName.isEmpty || updatedDescription.isEmpty) {
      _showErrorDialog("Both fields are required.");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // final bool success = await UpdateProjectService().updateProjectDetails(
    //   projectName: updatedName,
    //   projectDescription: updatedDescription,
    // );

    // if (!mounted) return;
    // setState(() {
    //   _isSubmitting = false;
    // });

    // if (success) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Project updated successfully!")),
    //   );
    //   widget
    //       .onProjectUpdated(); // Call the callback to refresh the project list
    //   Navigator.pop(context); // Navigate back after successful update
    // } else {

    // }

    try {
      final bool success = await UpdateProjectService().updateProjectDetails(
        projectId: widget.projectId,
        projectName: updatedName,
        projectDescription: updatedDescription,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project updated successfully!")),
        );
        widget
            .onProjectUpdated(); // Call the callback to refresh the project list
        Navigator.pop(context); // Navigate back after successful update
      } else {
        _showErrorDialog("Failed to update project. Please try again.");
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      print("Error: $e");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Project"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Project Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Project Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Project Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitUpdate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 8.0,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
