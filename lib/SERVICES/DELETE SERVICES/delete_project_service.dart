import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '/global.dart';
import '/UTILITIES/secure_storage_contents.dart';

class DeleteService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> deleteProject() async {
    final projectId = await _storage.read(key: 'projectIdentiForUrl');

    if (projectId == null) {
      throw Exception('Project ID is missing in secure storage');
    }

    final String endpoint = 'rpabot/project/delete/$projectId';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final UserOrgData _userOrgData = UserOrgData();
    final token = await _userOrgData.getJwtToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('token sent $token and project id sent $projectId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("response ${response.body}");
        return true;
      } else {
        // Handle errors (e.g., resource not found, unauthorized)
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle network errors
      print('Exception: $e');
      return false;
    }
  }
}
