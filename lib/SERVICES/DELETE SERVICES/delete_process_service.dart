import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '/global.dart';
import '/UTILITIES/secure_storage_contents.dart';

class DeleteProcessService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> deleteProcess(int processId) async {
    final UserOrgData _userOrgData = UserOrgData();
    final projectId = await _storage.read(key: 'projectIdentiForUrl');

    if (projectId == null) {
      throw Exception('Project ID is missing in secure storage');
    }
    final int? userId = await _userOrgData.getUserId();

    print("process id sent $processId");
    print('user id send $userId');

    final String endpoint = 'process/$processId/user/$userId';
    final url = Uri.parse(Global.getFullUrl(endpoint));

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
