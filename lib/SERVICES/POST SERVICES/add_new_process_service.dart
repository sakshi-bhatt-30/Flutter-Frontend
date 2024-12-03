import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '/global.dart';
import '../../UTILITIES/secure_storage_contents.dart'; // Import the file

class AddNewProcessService {
  final UserOrgData _userOrgData = UserOrgData(); // Instance of UserOrgData
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> addProcess(String? processName, String executionTime,
      bool active, String projectId) async {
    // Fetch userId, adminStatus, and projectIdWhenNotAdmin from secure storage
    int? userId = await _userOrgData.getUserId();
    final projectIdWhenNotAdmin =
        await _storage.read(key: 'projectIdentiForUrl');

    String? jwtToken =
        await _userOrgData.getJwtToken(); // Fetch JWT token from secure storage

    if (userId == null || jwtToken == null || projectIdWhenNotAdmin == null) {
      print(
          'Failed to retrieve userId, jwtToken, or projectIdWhenNotAdmin from secure storage');
      return false; // Return false if any required value is missing
    }

    final url = Uri.parse(Global.getFullUrl('process/add'));

    // Always use projectIdWhenNotAdmin
    final effectiveProjectId = projectIdWhenNotAdmin;

    // Prepare headers with Authorization bearer token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken', // Add the JWT token as Bearer token
    };

    print('URL being hit: $url');
    print('Headers being sent: $headers');
    print('Data being sent:');
    print({
      'processName': processName,
      'userId': userId.toString(), // Use the fetched userId
      'projectId': effectiveProjectId, // Always use projectIdWhenNotAdmin
      'executionTime': executionTime,
      'active': active.toString(), // Convert bool to string if necessary
    });

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'processName': processName,
        'userId': userId, // Use the fetched userId
        'projectId': effectiveProjectId, // Always use projectIdWhenNotAdmin
        'executionTime': executionTime,
        'active': active.toString(), // Convert bool to string if necessary
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Process added successfully');
      return true; // Process successfully added
    } else {
      print('Failed to add process: ${response.body}');
      return false; // Return false if there was an error
    }
  }
}
