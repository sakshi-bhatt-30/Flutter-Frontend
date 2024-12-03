import 'dart:convert';
import 'package:http/http.dart' as http;
import "../../MODALS/show_process_modal.dart";
import "../../Global.dart";
import '/UTILITIES/secure_storage_contents.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import

class ProcessService {
  final UserOrgData _userOrgData = UserOrgData();
  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // Create an instance of FlutterSecureStorage

  Future<List<Process>> fetchProcesses() async {
    // Retrieve projectIdentiForUrl from secure storage
    final projectId = await _storage.read(key: 'projectIdentiForUrl');

    // Check if projectId is available
    if (projectId == null) {
      throw Exception('Project ID is not available in secure storage');
    }

    // print the projectId
    print('Project ID: $projectId');

    // Retrieve the Bearer token from secure storage
    final token = await _userOrgData.getJwtToken();

    if (token == null) {
      throw Exception('JWT Token is not available in secure storage');
    }

    // print the token for debugging
    print('JWT Token: $token');

    // Construct the endpoint URL with projectId
    final String endpoint =
        'process/project/$projectId'; // Include projectId in the URL
    final url = Uri.parse(Global.getFullUrl(endpoint));

    // Set headers with Bearer token
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Add the token in the Authorization header
    };

    print(url);
    print('token sent: $token');

    final response = await http.get(url, headers: headers);

    print(response.body);
    print(response.headers);
    print("project id: $projectId");

    if (response.statusCode == 200) {
      final List<dynamic> processList = json.decode(response.body);
      return processList.map((json) => Process.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load processes');
    }
  }
}
