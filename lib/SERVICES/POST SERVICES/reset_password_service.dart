import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Global.dart';
import '../../MAIN_PAGES/ONBOARDING/LOGIN_PAGE/login.dart';

class ResetPasswordService {
  Future<String> resetPassword({
    required BuildContext context,
    required String otp,
    required String email,
    required String newPassword,
  }) async {
    String endpoint = 'RBM/resetPassword'; // Replace with your actual endpoint
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "otp": otp,
      "email": email,
      "newPassword": newPassword,
    });

    // Show loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final response = await http.post(url, headers: headers, body: body);
      print("Response: ${response.body}");
      print("Headers: ${response.headers}");
      print("URL: $url");
      print("Data sent: $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Password reset successful for $email");

        // Dismiss loader
        Navigator.of(context).pop();

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Password reset successful! Check your email: $email'),
            duration: Duration(seconds: 3),
          ),
        );

        // Show dialog box for 3 seconds indicating the password has been changed
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password has been changed successfully!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    // Navigate to UserLoginPage after 3 seconds
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserLoginPage()),
                      );
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        return 'success';
      } else {
        print("Error occurred with status code: ${response.statusCode}");
        Navigator.of(context).pop(); // Dismiss loader
        return 'error occurred';
      }
    } catch (e) {
      print('Error occurred: $e');
      Navigator.of(context).pop(); // Dismiss loader
      return 'error $e';
    }
  }
}
