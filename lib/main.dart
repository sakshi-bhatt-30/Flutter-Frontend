import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'MAIN_PAGES/HOME_PAGE/home_page.dart';
import 'UTILITIES/secure_storage_contents.dart';
// import '/UTILITIES/secure_storage_contents.dart'; // Reference to your UserOrgData class
// import 'MAIN_PAGES/ONBOARDING/LOGIN_PAGE/login.dart'; // Adjust the path to your login page
// import '/MAIN_PAGES/HOME_PAGE/home_page.dart'; // Adjust the path to your homepage
import 'MAIN_PAGES/ONBOARDING/landing.dart'; // Adjust the path if necessary

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final Logger _logger = Logger('FirebaseMessaging'); // Logger instance

  await Firebase.initializeApp();
  _logger.info(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final UserOrgData userOrgData = UserOrgData();

    return FutureBuilder<String?>(
      future: userOrgData.getJwtToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          return const Homepage(); // Navigate to the homepage if the token exists
        } else {
          return landingPage(); // Navigate to the login page if the token is empty
        }
      },
    );
  }
}
