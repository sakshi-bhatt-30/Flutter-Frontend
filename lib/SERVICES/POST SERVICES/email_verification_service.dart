import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Add this for Navigator
import 'package:rpa_bot_monitoring_ui/global.dart';
import '../../AUTHENTICATION/otp_verification.dart';
// import '/AUTHENTICATION/otp_verification.dart';

class EmailVerificationService {
  // Function to send the email via a POST request
  static Future<void> sendEmail(String email, BuildContext context) async {
    final Uri uri = Uri.parse(Global.getFullUrl('rpabot/send-otp'));

    // Creating the payload
    final Map<String, dynamic> data = {
      'email': email,
    };

    // Sending POST request
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json', // Specify content type as JSON
        },
        body: jsonEncode(data),
      );

      // Handle response
      if (response.statusCode == 200) {
        print('Email sent successfully!');

        // Navigate to OTPVerification page if the response is 200
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OTPVerification(email: email)),
        );
      } else {
        print('Failed to send email: ${response.statusCode}');
        // Handle error (e.g., show an error message)
      }
    } catch (e) {
      print('Error sending email: $e');
      // Handle error (e.g., show an error message)
    }
  }
}
