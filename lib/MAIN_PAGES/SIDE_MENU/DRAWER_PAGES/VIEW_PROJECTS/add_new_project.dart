import 'package:flutter/material.dart';
import '../../../../SERVICES/POST SERVICES/add_new_project_service.dart'; // Import your service

class AddNewProjectPage extends StatefulWidget {
  final VoidCallback onProjectAdded; // Callback to refresh the project list

  AddNewProjectPage({required this.onProjectAdded});

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddNewProjectPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitProject() async {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final bool success = await AddOrgService().addOrganization(
        name: name,
        description: description,
      );

      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project added successfully!")),
        );
        widget
            .onProjectAdded(); // Call the callback to refresh the project list
        Navigator.pop(context); // Navigate back after successful submission
      } else {
        _showErrorDialog("Failed to add project. Please try again.");
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      _showErrorDialog("An error occurred while submitting the project.");
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
        title: const Text("Add Project"),
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
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitProject,
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
                          'Submit Project',
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
