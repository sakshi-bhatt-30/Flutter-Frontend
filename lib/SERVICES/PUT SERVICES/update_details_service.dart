import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../global.dart';
import '../../UTILITIES/secure_storage_contents.dart';

class ProcessUpdateService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Method to update bot details
  Future<bool> updateBotDetails(
      Map<String, dynamic> updatedData, int processId) async {
    try {
      // Retrieve projectId from secure storage
      final projectId = await _storage.read(key: 'projectIdentiForUrl');

      if (projectId == null) {
        throw Exception('Project ID is missing in secure storage');
      }
      print('project id to url to edit $projectId');

      // Construct the endpoint
      final String endpoint = 'bot-schedule/update-schedule';
      final url = Uri.parse(Global.getFullUrl(endpoint));

      // Retrieve JWT token and userId
      final UserOrgData _userOrgData = UserOrgData();
      final token = await _userOrgData.getJwtToken();
      final userId = await _userOrgData.getUserId();

      if (token == null || userId == null) {
        throw Exception('Missing JWT Token or User ID in secure storage');
      }

      print('token in the edit bot details $token');

      // Prepare the payload
      final payload = {
        'userId': userId, // Add the userId
        'processId': processId, // Include processId for reference
        'startTime': updatedData['scheduleTime'] ?? [], // List of "HH:mm" times
        'repeatOption': updatedData['repeatOption'], // Convert to uppercase
        'active':
            updatedData['active'] ?? true, // Default to true if not provided
        if (updatedData['repeatOption'] == 'WEEKLY')
          'daysOfWeek': updatedData['selectedWeekDays'],
        if (updatedData['repeatOption'] == 'MONTHLY')
          'monthlyDays': updatedData['selectedMonthDays']
      };

      // Debugging details
      print("PUT Request URL: $url");
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Bot details updated successfully: ${response.body}");
        return true;
      } else {
        print(
            "Failed to update bot details. Status Code: ${response.statusCode}");

        if (response.body.isNotEmpty) {
          print("Error details: ${response.body}");
        } else {
          print("No additional error details from the server.");
        }
        return false;
      }
    } catch (e) {
      print("An unexpected error occurred while updating: $e");
      return false;
    }
  }
}
