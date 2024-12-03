import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
import '../../Global.dart';
import "../../MODALS/ongoing_modal.dart";
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';

class TaskService {
  Future<List<Task>> fetchTasks({required int projectId}) async {
    final UserOrgData _userOrgData = UserOrgData();
    // final Logger _logger = Logger('UserService'); // Logger instance

    try {
      final String? token = await _userOrgData.getJwtToken();
      // final int? projectId = await _userOrgData.getUserId();

      if (token == null) {
        print('JWT token or projectId is missing.');
        return [];
      }

      final String endpoint = 'ongoing-bots/project/$projectId';
      final url = Uri.parse(Global.getFullUrl(endpoint));

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("projectId sent $projectId");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((task) => Task.fromJson(task)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }
}
