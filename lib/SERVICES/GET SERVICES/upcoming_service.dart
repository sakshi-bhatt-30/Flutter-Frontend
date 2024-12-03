import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Global.dart';
import '../../MODALS/upcoming_modal.dart';
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';
// import 'package:logging/logging.dart'; // Logging framework

class UpcomingTaskService {
  final UserOrgData _userOrgData = UserOrgData();
  // final Logger _logger = Logger('UserService'); // Logger instance

  Future<List<UpcomingTask>> fetchUpcomingTasks(
      {required int projectId}) async {
    try {
      // Retrieve JWT token and project ID from secure storage
      final String? token = await _userOrgData.getJwtToken();
      // final int? projectId = await _userOrgData.getUserId();

      if (token == null) {
        print('JWT token or projectId is missing.');
        return [];
      }

      // Construct the URL with the project ID
      final String endpoint = 'upcoming-bots/project/$projectId';
      final url = Uri.parse(Global.getFullUrl(endpoint));

      // Make the GET request with the token in the headers
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          print('No upcoming tasks found.');
          return [];
        }
        return data.map((task) => UpcomingTask.fromJson(task)).toList();
      } else {
        print('Failed to load upcoming tasks: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching upcoming tasks: $e');
      return [];
    }
  }
}
