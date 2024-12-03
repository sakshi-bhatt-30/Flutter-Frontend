import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
import "../../Global.dart";
import '../../UTILITIES/secure_storage_contents.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class addMemberService {
  final UserOrgData _userOrgData = UserOrgData(); // Instance of
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> postUserData({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    // required String password,
    // required int projectId,
  }) async {
    // Get adminId (user_id) from secure storage
    int? adminId = await _userOrgData.getUserId();
    final String? token = await _userOrgData.getJwtToken();
    final projectIdWhenNotAdmin =
        await _storage.read(key: 'projectIdentiForUrl');
    // final Logger _logger = Logger('UserService'); // Logger instance

    if (token == null) {
      print('JWT token is missing.');
      return;
    }

    if (adminId == null) {
      print('Error: Admin ID not found in secure storage');
      return;
    }
    final effectiveProjectId = projectIdWhenNotAdmin;
    final String endpoint = 'rpabot/team/add';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobileNumber': mobileNumber,
      // 'password': password,
      'projectId': effectiveProjectId,
      'adminId': adminId, // Send adminId retrieved from secure storage
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Data posted successfully');
        // Handle success response
      } else {
        print('Failed to post data: ${response.statusCode}');
        // Handle failure response
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print('Error occurred: $e');
      // Handle error
    }

    print('Debug: Data received from frontend:');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Email: $email');
    print('Mobile Number: $mobileNumber');
    // print('Password: $password');
    // print('Project ID: $projectId');
    print('Admin ID: $adminId');
    print('\nDebug: Constructed request body: $body');
    print('Debug: Final URL: $url');
  }
}
