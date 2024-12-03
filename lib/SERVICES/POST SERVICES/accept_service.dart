import 'dart:convert';
import 'package:http/http.dart' as http;
import '/global.dart';
import '../../UTILITIES/secure_storage_contents.dart';

class postAccept {
  Future<void> postProcessData({
    required int processId,
    required String startTime,
    required String endTime,
    required String notificationTime,
    required String date,
    required int userId,
    required bool accepted,
  }) async {
    final url = Uri.parse(Global.getFullUrl(
        'executed-bots/create')); // Update with your endpoint path
    final UserOrgData _userOrgData = UserOrgData();

    final token = await _userOrgData.getJwtToken();

    // Construct the payload without remarks and status
    final Map<String, dynamic> payload = {
      'processId': processId,
      'startTime': startTime,
      'endTime': endTime,
      'notificationTime': notificationTime,
      'date': date,
      'userId': userId,
      'accepted': accepted,
    };
    print("payload : $payload");
    try {
      // Sending the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      // Check if the response status code indicates success
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Process data posted successfully');
        print(response.body);

        // Parse the response body to extract 'id'
        final responseData = json.decode(response.body);
        final acceptedId = responseData['id'];

        if (acceptedId != null) {
          // Set the extracted ID to Global.acceptedId
          Global.acceptedId = acceptedId;
          print(
              'Accepted ID has been successfully saved to Global: $acceptedId');
        } else {
          print('Failed to extract ID from response');
        }
      } else {
        // Log the error details if the request fails
        print('Failed to post process data: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (e) {
      // Log any exceptions that occur during the API call
      print('Error occurred while posting process data: $e');
    }
  }
}
