import 'package:flutter/material.dart';
import '../../../SERVICES/POST SERVICES/admin_signup_service.dart';
import '../LOGIN_PAGE/login.dart';

class AdminSignUpPage extends StatefulWidget {
  final String email; // Accept email from the previous page

  const AdminSignUpPage({Key? key, required this.email}) : super(key: key);

  @override
  _AdminSignUpPageState createState() => _AdminSignUpPageState();
}

class _AdminSignUpPageState extends State<AdminSignUpPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileNumberController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _organizationNameController;
  late final TextEditingController _organizationDescriptionController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController(
        text: widget.email); // Initialize with passed email
    _mobileNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _organizationNameController = TextEditingController();
    _organizationDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _organizationNameController.dispose();
    _organizationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Admin Signup',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 34),
                _buildTextField(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    }
                    if (value.length < 3 || value.length > 15) {
                      return 'First name must be 3-15 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    }
                    if (value.length < 3 || value.length > 15) {
                      return 'Last name must be 3-15 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  readOnly: true, // Make the email field non-editable
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _mobileNumberController,
                  hintText: 'Mobile Number',
                  icon: Icons.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Mobile number is required';
                    }
                    if (value.length < 10) {
                      return 'Enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _organizationNameController,
                  hintText: 'Organization Name',
                  icon: Icons.business,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Organization name is required';
                    }
                    if (value.length < 3) {
                      return 'Organization name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _organizationDescriptionController,
                  hintText: 'Organization Description',
                  icon: Icons.description,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Organization description is required';
                    }
                    if (value.length < 50) {
                      return 'Description must be at least 50 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      final registrationService = RegistrationService();
                      final String registrationResult =
                          await registrationService.postRegistrationDetails(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        mobileNumber: _mobileNumberController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmPasswordController.text,
                        organizationName: _organizationNameController.text,
                        organizationDescription:
                            _organizationDescriptionController.text,
                      );
                      setState(() {
                        _isLoading = false;
                      });

                      if (registrationResult == 'success') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserLoginPage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(registrationResult),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? Colors.grey
                          : const Color(0xFF61A3FA), // Grey out during loading
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false, // Add readOnly parameter
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly, // Apply readOnly property
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF676767)),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
        ),
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF676767)),
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
        ),
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        final passwordRegex = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
        if (!passwordRegex.hasMatch(value)) {
          return 'Password must include upper and lower case, digit, special character, and be at least 8 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF676767)),
        hintText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFA8A8A9)),
        ),
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF676767),
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm password is required';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
