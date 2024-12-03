import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:rpa_bot_monitoring_ui/MAIN_PAGES/HOME_PAGE/home_page.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../UTILITIES/secure_storage_contents.dart'; // Import for secure storage

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final Logger _logger = Logger('UserService'); // Logger instance

  // Controllers to manage the state of text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  // Create an instance of UserOrgData
  final UserOrgData _userOrgData = UserOrgData();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the page is initialized
  }

  // Method to load user data from secure storage
  Future<void> _loadUserData() async {
    String? firstName = await _userOrgData.getFirstName();
    String? lastName = await _userOrgData.getLastName();
    String? email = await _userOrgData.getemial();
    String? mobileNumber = await _userOrgData.getmobileNumber();

    setState(() {
      // Update the controllers with the retrieved values
      firstNameController.text = firstName ?? '';
      lastNameController.text = lastName ?? '';
      emailController.text = email ?? '';
      mobileController.text = mobileNumber ?? '';
    });

    // Log the data for debugging (optional)
    _logger.info('First Name: $firstName');
    _logger.info('Last Name: $lastName');
    _logger.info('Email: $email');
    _logger.info('Mobile Number: $mobileNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/my_picture.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Personal Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabelTextField('First Name', firstNameController),
            const SizedBox(height: 20),
            _buildLabelTextField('Last Name', lastNameController),
            const SizedBox(height: 20),
            _buildLabelTextField('Email Address', emailController),
            const SizedBox(height: 20),
            _buildLabelTextField('Mobile Number', mobileController),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  // Save button functionality
                  _logger.info('First Name: ${firstNameController.text}');
                  _logger.info('Last Name: ${lastNameController.text}');
                  _logger.info('Email: ${emailController.text}');
                  _logger.info('Mobile Number: ${mobileController.text}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set background color to blue
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
