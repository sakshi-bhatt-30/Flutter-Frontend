import 'package:flutter/material.dart';
import '/SERVICES/POST SERVICES/send_email_service.dart';
import 'email_verification.dart'; // Import the SendEmailService

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final SendEmailService _emailService =
      SendEmailService(); // Instance of the service

  // Email validation function
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address'; // Return error message for empty email
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address'; // Return error message for invalid email
    }
    return null; // Valid email, no error
  }

  // Submit function for Forgot Password
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();

      // Call the API to send the email
      String result = await _emailService.postEmail(
        context: context,
        email: email,
      );

      // Handle the result and show feedback
      if (result == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check your email: $email'),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to the next page and pass the email
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EnterNewPassword(email: email), // Pass email
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send email. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned(
                  left: 30,
                  top: 215,
                  child: Text(
                    'Forgot\npassword?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
                Positioned(
                  left: 29,
                  top: 508,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF61A3FA),
                      minimumSize: Size(317, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: _submit, // Call the submit function
                    child: Text(
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
                Positioned(
                  left: 30,
                  top: 460,
                  child: SizedBox(
                    width: 282,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: Color(0xFFFF4B26),
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' We will send you a message to set or reset your new password',
                            style: TextStyle(
                              color: Color(0xFF676767),
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 29,
                  top: 361,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: 317,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF3F3F3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xFFA8A8A9), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Color(0xFFA8A8A9), width: 1),
                          ),
                          hintText: 'Enter your email address',
                          hintStyle: TextStyle(
                            color: Color(0xFF676767),
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xFF676767),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail, // Email validation
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 777,
                  child: Container(
                    width: 375,
                    height: 35,
                    child: Center(
                      child: Container(
                        width: 134,
                        height: 5,
                        decoration: ShapeDecoration(
                          color: Color(0xFFA8A8A9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
