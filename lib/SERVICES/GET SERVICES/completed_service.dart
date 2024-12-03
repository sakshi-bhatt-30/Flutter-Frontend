import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:logging/logging.dart';
import '../../Global.dart';
import '../../MODALS/completed_modal.dart';
// import '../../MODALS/executed_bot_modal.dart'; // Updated model import
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';

class CompletedTaskService {
  final UserOrgData _userOrgData = UserOrgData();
  // final Logger _logger = Logger('UserService'); // Logger instance

  Future<List<ExecutedBot>> fetchCompletedTasks({required int projectId}) async {
    final String? token = await _userOrgData.getJwtToken();
    
    final String endpoint = 'executed-bots/project/$projectId';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> taskList = json.decode(response.body);
        if (taskList.isEmpty) {
          print('No executed bots found.');
          return [];
        }
        return taskList.map((task) => ExecutedBot.fromJson(task)).toList();
      } else {
        print('Failed to load executed bots: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching executed bots: $e');
      return [];
    }
  }

  Future<ExecutedBot?> fetchCompletedTaskById(int executedBotId) async {
    final String? token = await _userOrgData.getJwtToken();

    final String endpoint = 'executed-bots/$executedBotId';
    final url = Uri.parse(Global.getFullUrl(endpoint));

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final task = json.decode(response.body);
        if (task == null || task.isEmpty) {
          print('No executed bot found with the given ID.');
          return null;
        }
        return ExecutedBot.fromJson(task);
      } else {
        print('Failed to load executed bot: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching executed bot: $e');
      return null;
    }
  }
}
