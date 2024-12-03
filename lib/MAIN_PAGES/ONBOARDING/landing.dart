import 'package:flutter/material.dart';
import '../../AUTHENTICATION/email_otp_verification.dart';
import 'SIGNUP_PAGE/admin_signup.dart';
import 'LOGIN_PAGE/login.dart';
// import 'SIGNUP_PAGE/signup.dart';

class landingPage extends StatelessWidget {
  Widget customElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(150, 55), // Set the size of the button
        backgroundColor: Color(0xFF61A3FA), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Center image
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/onboarding.png', // Path to the custom image
                width: 150.0, // Width of the image
                height: 150.0, // Height of the image
              ),
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customElevatedButton('Login', () {
                  // Show the login choice dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserLoginPage()),
                  );
                }),
                customElevatedButton('Signup', () {
                  // Navigate to SignupPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEmailPage()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
