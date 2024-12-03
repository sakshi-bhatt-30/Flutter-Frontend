import 'package:firebase_core/firebase_core.dart';
import 'package:logging/logging.dart';


class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
    final Logger _logger = Logger('UserService'); // Logger instance


  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      _logger.info("Starting Firebase initialization...");
      await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
      );
      _logger.info("Firebase initialized successfully.");
    } else {
      _logger.info("Firebase already initialized.");
    }
  }
}
