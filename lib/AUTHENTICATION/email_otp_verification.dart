import 'package:flutter/material.dart';

import '../SERVICES/POST SERVICES/email_verification_service.dart';

class AddEmailPage extends StatefulWidget {
  const AddEmailPage({Key? key}) : super(key: key);

  @override
  _AddEmailPageState createState() => _AddEmailPageState();
}

class _AddEmailPageState extends State<AddEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false; // Add a flag for loading state

  // Function to handle email submission
  Future<void> _submitEmail() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email is required.';
      });
      return;
    }

    // Validate email format (basic regex)
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address.';
      });
      return;
    }

    setState(() {
      _emailError = null; // Clear error if email is valid
      _isLoading = true; // Show loader when submitting
    });

    // Call the PostService to send the email
    try {
      await EmailVerificationService.sendEmail(
          email, context); // Pass context here
      // No need for navigation here, it's handled in the service method
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loader once submission is complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Page content
          Positioned(
            left: 30,
            top: 215,
            child: Text(
              'HELLO!',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Email Input Section
          Positioned(
            left: 30,
            top: 300,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your email address here",
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 315,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB0B0B0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Color(0xFF61A3FA)),
                        ),
                      ),
                    ),
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _emailError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Submit Button
          Positioned(
            left: 29,
            top: 488,
            child: GestureDetector(
              onTap: _submitEmail, // Call the function when tapped
              child: Container(
                width: 317,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF61A3FA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
