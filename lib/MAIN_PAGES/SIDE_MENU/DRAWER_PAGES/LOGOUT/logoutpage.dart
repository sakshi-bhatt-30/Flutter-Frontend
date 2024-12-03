import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '/MAIN_PAGES/ONBOARDING/LOGIN_PAGE/login.dart';

class LogoutPage extends StatelessWidget {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show the confirmation dialog as soon as the page is built
    Future.microtask(() => _showConfirmationDialog(context));
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Placeholder while dialog is shown
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pop(context); // Return to the previous page
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await logout(context); // Proceed to log out
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Await clearing all stored data in secure storage
      await _secureStorage.deleteAll();
      print("JWT token and other data cleared successfully.");

      // Ensure that the navigation is also awaited if necessary
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserLoginPage()),
        (route) => false, // Remove all previous routes
      );
    } catch (e) {
      print("Error during logout: $e");
      _showErrorDialog(context, "An error occurred while logging out.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
