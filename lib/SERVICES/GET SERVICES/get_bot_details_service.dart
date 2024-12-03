import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';
import '/global.dart';
import '/MODALS/get_bot_details_modal.dart'; // Import the Process model

class GetBotDetails {
  final String baseUrl;

  GetBotDetails(this.baseUrl);

  Future<GetDetails> getProcess(int processId) async {
    final UserOrgData _userOrgData = UserOrgData();
    String? token = await _userOrgData.getJwtToken();

    if (token == null || token.isEmpty) {
      print("Error: Token is null or empty.");
      throw Exception("Token is missing. Please try again.");
    }
    final url = Uri.parse(
        Global.getFullUrl('bot-schedule/process/$processId')); // API endpoint
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Add the token in the Authorization header
    };

    print("URL to get details $url");
    print('Token sent: $token');
    final response = await http.get(url, headers: headers);
    print("Response Body: ${response.body}"); // Log the response body
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Parse JSON and return a Process object
      return GetDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load process');
    }
  }
}
