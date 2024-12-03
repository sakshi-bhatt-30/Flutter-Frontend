import 'package:flutter/material.dart';
// import '../../../../MODALS/projects_modal.dart';
// import '../../../../MODALS/show_project_modal.dart';
import '../../../../SERVICES/POST SERVICES/add_team_member_service.dart'; // Import the service

class AddTeamPage extends StatefulWidget {
  const AddTeamPage({super.key});

  @override
  _AddTeamPageState createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final addMemberService _addMemberService = addMemberService();

  List<Map<String, String>> _teamMembers = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitTeam() async {
    if (_teamMembers.isEmpty) {
      _showErrorDialog("Please add at least one team member.");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      for (var member in _teamMembers) {
        await _addMemberService.postUserData(
          firstName: member['firstName']!,
          lastName: member['lastName']!,
          email: member['email']!,
          mobileNumber: member['mobile']!,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Team members added successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorDialog("Failed to add team members. Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
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

  void _addTeamMember() {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final mobile = _mobileController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        mobile.isEmpty) {
      _showErrorDialog("Please fill all fields before adding a team member.");
      return;
    }

    if (_teamMembers.any((member) => member['email'] == email)) {
      _showErrorDialog("This member has already been added.");
      return;
    }

    if (mounted) {
      setState(() {
        _teamMembers.add({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'mobile': mobile,
        });
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _mobileController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Enter Team Member Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addTeamMember,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text("Add Member",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF61A3FA),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _teamMembers.clear();
                        }),
                        child: const Text("Clear All Members",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Added Members:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _teamMembers.length,
                    itemBuilder: (context, index) {
                      final member = _teamMembers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Name: ${member['firstName']} ${member['lastName']}'),
                              Text('Email: ${member['email']}'),
                              Text('Mobile: ${member['mobile']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitTeam,
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Submit Team',
                            style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF61A3FA),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
