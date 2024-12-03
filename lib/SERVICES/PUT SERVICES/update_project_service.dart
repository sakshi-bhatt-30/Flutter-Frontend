import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../UTILITIES/secure_storage_contents.dart';
import '../../global.dart';

class UpdateProjectService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final UserOrgData _userOrgData = UserOrgData();

  // Method to update project details
  Future<bool> updateProjectDetails({
    required String projectId,
    required String projectName,
    required String projectDescription,
  }) async {
    try {
      // Validate the project ID
      if (projectId.isEmpty) {
        throw Exception('Project ID is missing or invalid');
      }

      // Construct the endpoint
      final String endpoint = 'rpabot/project/update/$projectId';
      final url = Uri.parse(Global.getFullUrl(endpoint));

      // Retrieve JWT token
      final String? token = await _userOrgData.getJwtToken();
      if (token == null) {
        throw Exception('JWT Token is missing in secure storage');
      }

      print("token sent $token");

      // Prepare the payload
      final Map<String, dynamic> payload = {
        'projectName': projectName,
        'projectDescription': projectDescription,
      };

      // Debugging details
      print("PUT Request URL: $url");
      print('project id $projectId');
      print('project name $projectName');
      print('project description $projectDescription');
      print("PUT Payload: ${jsonEncode(payload)}");

      // Make the PUT request
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      // Check the response
      if (response.statusCode == 200) {
        print("Project details updated successfully: ${response.body}");
        return true;
      } else {
        print(
            "Failed to update project details. Status Code: ${response.statusCode}");
        if (response.body.isNotEmpty) {
          print("Error details: ${response.body}");
        } else {
          print("No additional error details from the server.");
        }
        return false;
      }
    } catch (e) {
      print("An unexpected error occurred while updating the project: $e");
      return false;
    }
  }
}
