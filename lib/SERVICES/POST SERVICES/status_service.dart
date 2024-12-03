import 'dart:convert';
import 'package:http/http.dart' as http;
import "../../Global.dart"; // Assuming you have a Global class for managing API URLs
import '../../UTILITIES/secure_storage_contents.dart';

class statusService {
  Future<void> updateTask(int id, String status, String remarks) async {
    final String endpoint =
        'executed-bots/update-status-remarks'; // Endpoint for updating the task
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final UserOrgData _userOrgData = UserOrgData();

    final token = await _userOrgData.getJwtToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = json.encode({
      'id': id,
      'status': status,
      'remarks': remarks,
    });
    print("body:  $body");
    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Task updated successfully');
        print(response.body);
        // Handle success response, possibly return something if needed
      } else {
        print('Failed to update task: ${response.statusCode}');
        // Handle failure response
        throw Exception('Failed to update task');
      }
    } catch (e) {
      print('Error occurred: $e');
      // Handle error, possibly throw or return a custom error
    }
  }
}
