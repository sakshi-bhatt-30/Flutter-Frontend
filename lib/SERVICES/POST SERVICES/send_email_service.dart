import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Global.dart';

class SendEmailService {
  Future<String> postEmail({
    required BuildContext context,
    required String email,
  }) async {
    String endpoint = 'RBM/forgetPassword';
    final url = Uri.parse(Global.getFullUrl(endpoint));
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({'email': email});

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
      print("Data from front end: $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Email sent to $email");

        // Dismiss loader
        Navigator.of(context).pop();

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Check your email: $email'),
            duration: Duration(seconds: 3),
          ),
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
