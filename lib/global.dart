import 'package:shared_preferences/shared_preferences.dart';

class Global {
  // static const String baseUrl = "http://192.168.1.14:8080"; // msl 5g ip purushottam
  // static const String baseUrl = "http://192.168.1.53:8080"; // msl 5g ip
  static const String baseUrl =
      "http://192.168.1.10:8080"; // msl aritel_msl_tech ip
  // static const String baseUrl =
  //     "http://192.168.1.26:8080"; // airtel msl tech ip

  // static const String baseUrl = "http://192.168.240.167:8080"; home ip

  // static const String baseUrl =
  //     "http://155.248.254.4:8080"; // msl aritel_msl_tech ip
  static int? acceptedId;

  static String getFullUrl(String endpoint) {
    return '$baseUrl/$endpoint';
  }

  // Save auth token in local storage
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // Retrieve auth token from local storage
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Clear auth token from local storage
  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
