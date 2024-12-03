import 'package:flutter/material.dart';
import '../../../SERVICES/GET SERVICES/get_user_info_service.dart';
import '../../../SERVICES/POST SERVICES/login_service.dart';
import '../../../SERVICES/GET SERVICES/notification_services.dart';
import '../../HOME_PAGE/home_page.dart';
import '../FORGOT_PASSWORD_ACTIONS/forgot_password.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false; // New variable to track loading state

  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    setupNotificationServices();
  }

  Future<void> setupNotificationServices() async {
    try {
      notificationServices.requestNotificationPermission();
      notificationServices.isTokenRefresh();
      await notificationServices.setupInteractMessage(context);
      notificationServices.firebaseInit(context);
    } catch (e) {
      debugPrint("Error setting up notification services: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 171),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome \nBack!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              buildInputField(
                controller: _usernameController,
                hintText: 'Username or Email',
                icon: Icons.person,
              ),
              const SizedBox(height: 25),
              buildInputField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF676767),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF61A3FA),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  if (mounted) {
                    setState(() {
                      _isLoading = true; // Set loading to true
                    });
                  }

                  final loginService = LoginService();
                  final isLoggedIn = await loginService.login(
                    context,
                    _usernameController.text.trim(),
                    _passwordController.text.trim(),
                  );

                  if (isLoggedIn) {
                    try {
                      final userService = UserService();
                      final userData =
                          await userService.fetchUserData(); // Fetch user data

                      // Log or use the fetched user data
                      print(
                          "User Data: ${userData.firstName} ${userData.lastName}");

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint("Error fetching user data: $e");
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid username or password'),
                        ),
                      );
                    }
                  }

                  if (mounted) {
                    setState(() {
                      _isLoading =
                          false; // Set loading to false after login attempt
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF61A3FA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: _isLoading // Show the loader while loading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA8A8A9)),
        color: const Color(0xFFF3F3F3),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF676767)),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF676767)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
