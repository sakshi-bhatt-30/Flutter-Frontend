import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
import '../../Global.dart';
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';

class AddOrgService {
  final UserOrgData _userOrgData =
      UserOrgData(); // Create an instance of UserOrgData

  // Function to add organization
  Future<bool> addOrganization({
    required String name,
    required String description,
  }) async {
    // Retrieve userId, orgId, and JWT token from secure storage
    int? userId = await _userOrgData.getUserId();
    int? orgId = await _userOrgData.getOrgId();
    String? token = await _userOrgData.getJwtToken();
      // final Logger _logger = Logger('UserService'); // Logger instance


    if (userId == null || orgId == null || token == null) {
      print('Failed to retrieve userId, orgId, or token');
      return false; // Return false if any of the required data is missing
    }

    final String endpoint = 'rpabot/project/add';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Add the token to the Authorization header
    };

    final body = json.encode({
      'orgId': orgId,
      'name': name,
      'userId': userId,
      'description': description,
    });

    // print the data being sent
    print('Sending POST request to: $url');
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming 200 is the success status code
        print('project added successfully');
        print('response: ${response.body}');
        return true;
      } else {
        print('Failed to add project: ${response.statusCode}');
        print(
            'Response body: ${response.body}'); // print the response body for additional details
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}
