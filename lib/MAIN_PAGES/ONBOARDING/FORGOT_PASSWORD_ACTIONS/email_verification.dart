import 'package:flutter/material.dart';
import '../../../SERVICES/POST SERVICES/reset_password_service.dart';

class EnterNewPassword extends StatefulWidget {
  final String email; // Email from the previous page

  EnterNewPassword({required this.email});

  @override
  _EnterNewPasswordState createState() => _EnterNewPasswordState();
}

class _EnterNewPasswordState extends State<EnterNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isPasswordVisible = false; // Boolean to manage password visibility
  bool _isLoading = false; // Loader flag

  // OTP validation function
  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    }
    if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Please enter a valid 6-digit OTP';
    }
    return null;
  }

  // Password validation function
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid password';
    }
    String passwordPattern =
        r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (!RegExp(passwordPattern).hasMatch(value)) {
      return '''Password must be at least 8 characters long,\nwith at least one uppercase letter, one number,\nand one special character.''';
    }
    return null;
  }

  // Submit function to handle form submission
  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loader
      });

      String otp = _otpController.text.trim();
      String password = _passwordController.text.trim();

      // Call the reset password service
      String result = await ResetPasswordService().resetPassword(
        context: context,
        otp: otp,
        email: widget.email,
        newPassword: password,
      );

      setState(() {
        _isLoading = false; // Hide loader
      });

      // Handle the result (e.g., show a message or navigate)
      if (result == 'success') {
        // Optionally, navigate to another screen, such as login or home
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Positioned(
                      left: 30,
                      top: 215,
                      child: Text(
                        'Enter\nNew Password',
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
                      top: 600,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF61A3FA),
                          minimumSize: Size(317, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: _submit,
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
                      left: 29,
                      top: 300,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // Email field (read-only)
                            Container(
                              width: 317,
                              child: TextFormField(
                                initialValue: widget.email,
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF3F3F3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xFFA8A8A9), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xFFA8A8A9), width: 1),
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF676767),
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color(0xFF676767),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // OTP field
                            Container(
                              width: 317,
                              child: TextFormField(
                                controller: _otpController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF3F3F3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xFFA8A8A9), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xFFA8A8A9), width: 1),
                                  ),
                                  hintText: 'Enter OTP',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF676767),
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_clock,
                                    color: Color(0xFF676767),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: _validateOtp,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Password field with eye icon to toggle visibility
                            Container(
                              width: 317,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText:
                                    !_isPasswordVisible, // Toggle password visibility
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFF3F3F3),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xFFA8A8A9), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color(0xFFA8A8A9), width: 1),
                                  ),
                                  hintText: 'Enter new password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF676767),
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(0xFF676767),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFF676767),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                          ],
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
            // Loader overlay
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
