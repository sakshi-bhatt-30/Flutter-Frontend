import 'dart:convert';
import 'package:http/http.dart' as http;
import "../../Global.dart"; // Assuming you have a Global class for managing API URLs

class otpService {
  Future<int> verifyOtp({required String email, required String otp}) async {
    final String endpoint =
        'rpabot/verify-email'; // Replace with your actual endpoint
    final url = Uri.parse(Global.getFullUrl(endpoint));

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'email': email,
      'otp': otp,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('OTP verification successful');
        print(response.body);
        return response.statusCode; // Return status code for further processing
      } else {
        print('Failed to verify OTP: ${response.statusCode}');
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow; // Throw error so the caller can handle it
    }
  }
}
