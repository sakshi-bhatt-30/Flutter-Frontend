import 'dart:convert';
import 'package:http/http.dart' as http;
import '/global.dart';
import '../../MODALS/get_user_info_modal.dart';
import '../../UTILITIES/secure_storage_contents.dart'; // Import the secure storage utility
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import the secure storage package

class UserService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Method to fetch user data
  Future<UserModel> fetchUserData() async {
    final UserOrgData _userOrgData = UserOrgData();
    int? userId = await _userOrgData.getUserId();
    String? token = await _userOrgData.getJwtToken();

    if (token == null || token.isEmpty) {
      print("Error: Token is null or empty.");
      throw Exception("Token is missing. Please try again.");
    }

    final url = Uri.parse(Global.getFullUrl('rpabot/$userId'));

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Add the token in the Authorization header
    };

    try {
      print(url);
      print('Token sent: $token');
      final response = await http.get(url, headers: headers);

      print("Response Body: ${response.body}"); // Log the response body
      print("Response Status Code: ${response.statusCode}");

      // Check if the response is in JSON format (status code 200)
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body); // Try decoding the response
          print("Decoded data: $data");

          // Extract first name and last name from the decoded data
          String firstName = data['firstName'];
          String lastName = data['lastname'] ?? '';
          String email = data['email'] ?? '';
          String mobileNumber = data['mobileNumber'] ?? '';

          // Save first name and last name to secure storage
          await _secureStorage.write(key: 'firstName', value: firstName);
          await _secureStorage.write(key: 'lastName', value: lastName);
          await _secureStorage.write(key: 'email', value: email);
          await _secureStorage.write(key: 'mobileNumber', value: mobileNumber);

          // Return the UserModel
          return UserModel.fromJson(data);
        } catch (e) {
          // Handle JSON decoding errors
          print("Error decoding JSON: $e");
          throw Exception(
              "Failed to decode user data. Invalid response format.");
        }
      } else {
        print(
            "Error: Failed to fetch user data. Status code: ${response.statusCode}");
        throw Exception('Failed to fetch user data. Please try again.');
      }
    } catch (e) {
      print("Error fetching user data: $e");
      throw Exception('Error: $e');
    }
  }
}
