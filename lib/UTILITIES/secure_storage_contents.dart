import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class UserOrgData {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Logger _logger = Logger('UserService'); // Logger instance

  // Method to get userId from secure storage
  Future<int?> getUserId() async {
    String? userId = await _secureStorage.read(key: 'user_id');
    return userId != null ? int.tryParse(userId) : null;
  }

  // Method to get orgId from secure storage
  Future<int?> getOrgId() async {
    String? orgId = await _secureStorage.read(key: 'org_id');
    return orgId != null ? int.tryParse(orgId) : null;
  }

  // Method to get JWT token from secure storage
  Future<String?> getJwtToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  // Method to get admin status from secure storage
  Future<String?> getAdminStatus() async {
    return await _secureStorage.read(key: 'isAdmin'); // No arguments needed
  }

  // Method to get firstName from secure storage
  Future<String?> getFirstName() async {
    return await _secureStorage.read(key: 'firstName');
  }

  // Method to get lastName from secure storage
  Future<String?> getLastName() async {
    return await _secureStorage.read(key: 'lastName');
  }

  Future<String?> getemial() async {
    return await _secureStorage.read(key: 'emial');
  }

  Future<String?> getmobileNumber() async {
    return await _secureStorage.read(key: 'mobileNumber');
  }

  // Method to save data to secure storage
  Future<void> saveToStorage(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      _logger.info('DEBUG: Saved $key with value $value to secure storage.');
    } catch (e) {
      _logger.info('DEBUG: Error saving $key to secure storage: $e');
    }
  }

  // Retrieve a value from secure storage
  Future<String?> getFromStorage(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      _logger
          .info('DEBUG: Retrieved $key with value $value from secure storage.');
      return value;
    } catch (e) {
      _logger.info('DEBUG: Error retrieving $key from secure storage: $e');
      return null;
    }
  }
}
