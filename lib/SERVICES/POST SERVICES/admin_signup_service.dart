import 'dart:convert';
import 'package:http/http.dart' as http;
import "../../Global.dart"; // Assumes you have a Global class for managing API URLs

class RegistrationService {
  Future<String> postRegistrationDetails({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String password,
    required String confirmPassword,
    required String organizationName,
    required String organizationDescription,
  }) async {
    // Trim the firstName to remove any extra spaces
    firstName = firstName.trim();

    // Check if firstName is within the required length
    if (firstName.length < 3 || firstName.length > 15) {
      return 'First name must be between 3 to 15 characters.';
    }

    final String endpoint = 'rpabot/create/admin';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      'password': password,
      'confirmPassword': confirmPassword,
      'organizationName': organizationName,
      'organizationDescription': organizationDescription,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("response ${response.body}");
      print("headers ${response.headers}");
      print("url hit $url");
      print("data from front end $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Registration successful');
        print('data from frontend $body');
        print(response.body);
        return 'success'; // Indicate success
      } else if (response.statusCode == 400) {
        return 'Bad Request: Check input fields for errors.';
      } else if (response.statusCode == 409) {
        return 'Conflict: Email or mobile number already exists.';
      } else if (response.statusCode == 500) {
        return 'Server error: Please try again later.';
      } else {
        return 'Failed to register: ${response.statusCode}';
      }
    } catch (e) {
      print('Error occurred: $e');
      return 'Error: $e';
    }
  }
}
