import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../MAIN_PAGES/HOME_PAGE/home_page.dart';
import '/global.dart';
import 'dart:convert';
import '/SERVICES/GET SERVICES/notification_services.dart';

class LoginService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final NotificationServices notificationServices = NotificationServices();

  Future<bool> login(
      BuildContext context, String username, String password) async {
    try {
      // Retrieve device token from NotificationServices
      String deviceToken = await notificationServices.getDeviceToken();

      print(
          "Front-end data: Username=$username, Password=$password, DeviceToken=$deviceToken");

      // Construct the request URL
      final url = Uri.parse(Global.getFullUrl('RBM/login'));

      // Make the HTTP POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'deviceToken': deviceToken,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Device token: $deviceToken");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the homepage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final token = responseBody['jwtToken'];
        if (token == null) {
          print("Error: Token not found in the response.");
          _showErrorDialog(
              context, "Invalid response format. Please try again.");
          return false;
        }
        print("Login Successful: Token received $token");

        try {
          // Decode the JWT token
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          print("Decoded Token: $decodedToken");

          final userId = decodedToken['userId'];
          final orgId = decodedToken['orgId'];
          final isAdmin = decodedToken['isAdmin'];

          print('The user ID is $userId, org ID is $orgId, Admin: $isAdmin');

          if (userId == null || orgId == null || isAdmin == null) {
            print("Error: userId, orgId, or isAdmin not found in the token.");
            _showErrorDialog(
                context, "Token structure is invalid. Please try again.");
            return false;
          }

          // Save the token securely
          await _secureStorage.write(key: 'jwt_token', value: token);
          await _secureStorage.write(key: 'user_id', value: userId.toString());
          await _secureStorage.write(key: 'org_id', value: orgId.toString());
          await _secureStorage.write(key: 'isAdmin', value: isAdmin.toString());
          print("Admin status saved successfully: $isAdmin");

          return true;
        } catch (e) {
          print("Token Decoding Error: $e");
          _showErrorDialog(context, "Invalid token format. Please try again.");
          return false;
        }
      } else {
        print("Login Failed: ${response.body}");
        _showErrorDialog(
            context, "Login failed. Please check your credentials.");
        return false;
      }
    } catch (e) {
      print("Login Error: $e");
      _showErrorDialog(
          context, "An unexpected error occurred. Please try again.");
      return false;
    }
  }

  void _showErrorDialog(BuildContext parentContext, String message) {
    showDialog(
      context: parentContext,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(parentContext).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
