import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../Global.dart';
import '../../MODALS/show_project_modal.dart';
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';
// import 'package:logging/logging.dart'; // Logging framework

class OrganizationService {
  final UserOrgData _userOrgData = UserOrgData();
  final _storage = FlutterSecureStorage(); // Instance of FlutterSecureStorage
  // final Logger _logger = Logger('UserService'); // Logger instance

  Future<String?> getProjectIdentiForUrl() async {
    try {
      String? projectIdentiForUrl =
          await _storage.read(key: 'projectIdentiForUrl');
      return projectIdentiForUrl;
    } catch (e) {
      print('Error retrieving project identifier: $e');
      return null;
    }
  }

  // Fetch list of organizations
  Future<List<Organization>> fetchOrganizations() async {
    try {
      // Retrieve JWT token and userId
      final String? token = await _userOrgData.getJwtToken();
      final int? userId = await _userOrgData.getUserId();

      if (token == null || userId == null) {
        print('Error: JWT token or user ID is null');
        return [];
      }

      final String endpoint = 'rpabot/project/user/$userId';
      final url = Uri.parse(Global.getFullUrl(endpoint));
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> orgList = json.decode(response.body);
        if (orgList.isEmpty) {
          print('No project found');
          print('No projects found.');
          print(userId);
          print(response.statusCode);
          return [];
        }

        // Extract project IDs and names
        final projects = orgList.map((org) {
          return {
            'id': org['projectId'] ?? 1,
            'name': org['projectName'],
          };
        }).toList();

        // Save project details
        await saveProjects(projects);

        return orgList.map((org) => Organization.fromJson(org)).toList();
      } else {
        print(
            'Failed to load projects. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  // Save projects (IDs and names) to secure storage
  Future<void> saveProjects(List<Map<String, dynamic>> projects) async {
    try {
      final projectsString = json.encode(projects);
      await _userOrgData.saveToStorage('projects', projectsString);
      // print('DEBUG: Projects saved: $projects');
    } catch (e) {
      print('DEBUG: Error saving projects: $e');
    }
  }

  Future<String?> getSavedProjectIdentiForUrl() async {
    try {
      final String? projectIdentiForUrl =
          await _storage.read(key: 'projectIdentiForUrl');
      return projectIdentiForUrl;
    } catch (e) {
      print('Error retrieving project identifier: $e');
      return null;
    }
  }

  // Retrieve projects from secure storage
  Future<List<Map<String, dynamic>>?> getSavedProjects() async {
    try {
      final String? projectsString =
          await _userOrgData.getFromStorage('projects');
      if (projectsString != null) {
        final List<dynamic> projects = json.decode(projectsString);
        return projects.map((project) {
          return {
            'id': project['id'],
            'name': project['name'],
          };
        }).toList();
      }
      return null;
    } catch (e) {
      print('DEBUG: Error retrieving projects: $e');
      return null;
    }
  }
}
