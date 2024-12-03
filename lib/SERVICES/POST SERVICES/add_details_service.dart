import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
import '../../global.dart';
import '../../UTILITIES/secure_storage_contents.dart';

class AddBotService {
  // Method to submit form data
  static Future<bool> submitBotDetails(
      Map<String, dynamic> formData, int userId, int processId) async {
    final String endpoint = 'bot-schedule/add-schedule';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final UserOrgData _userOrgData = UserOrgData();
    // final Logger _logger = Logger('UserService'); // Logger instance

    final token = await _userOrgData.getJwtToken();
    final userId = await _userOrgData.getUserId();

    if (token == null) {
      throw Exception('JWT Token is not available in secure storage');
    }

    print('JWT Token: $token');

    // Prepare the payload in the desired format
    final payload = {
      'userId': userId, // Use the passed userId
      'processId': processId, // Use the passed processId
      'startTime':
          formData['scheduleTime'] ?? [], // List<String> of "HH:mm" times
      'repeatOption':
          formData['repeatOption']?.toUpperCase(), // Convert to uppercase
      'active': true, // Set the active status
      // Conditionally include daysOfWeek if repeatOption is "Weekly"
      if (formData['repeatOption'] == 'WEEKLY')
        'DaysOfWeek': formData['selectedWeekDays'],
      if (formData['repeatOption'] == 'MONTHLY')
        'monthlyDays': formData['selectedMonthDays']
    };

    // print URL for debugging
    print("Full URL: $url");
    print("Process ID: $processId");

    try {
      print("Sending request to $url with payload: ${jsonEncode(payload)}");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      // Check if the response indicates success
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Data submitted successfully with response: ${response.body}");
        return true;
      } else {
        print("Failed to submit data. Status code: ${response.statusCode}");
        if (response.body.isNotEmpty) {
          print("Error details: ${response.body}");
        } else {
          print("No additional error details from server.");
        }
        return false;
      }
    } catch (e) {
      print("An unexpected error occurred: $e");
      return false;
    }
  }
}
