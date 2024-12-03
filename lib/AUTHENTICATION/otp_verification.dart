import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../SERVICES/POST SERVICES/otp_verification_service.dart';
import '../MAIN_PAGES/ONBOARDING/SIGNUP_PAGE/admin_signup.dart'; // Ensure correct path

class OTPVerification extends StatefulWidget {
  final String email; // Only email is passed

  const OTPVerification({Key? key, required this.email}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final TextEditingController _otpController = TextEditingController();
  String? _otpError;
  bool _isLoading = false;

  // Function to handle OTP verification
  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });
    final otp = _otpController.text;
    final email = widget.email;

    if (otp.isEmpty) {
      setState(() {
        _otpError = 'OTP is required.';
        _isLoading = false;
      });
      return;
    }

    if (otp.length != 6) {
      setState(() {
        _otpError = 'OTP must be 6 digits long.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _otpError = null; // Clear error if OTP is valid
    });

    try {
      final registrationService = otpService();
      final statusCode = await registrationService.verifyOtp(
        email: email,
        otp: otp,
      );

      // Handle the response status code
      if (statusCode == 200 || statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified Successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AdminSignUpPage(email: email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verification failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 30,
            top: 215,
            child: Text(
              'Enter OTP',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 300,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter the 6-digit OTP sent on your mail ID",
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 315,
                    child: Pinput(
                      controller: _otpController,
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 50,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF61A3FA)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  if (_otpError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _otpError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 29,
            top: 488,
            child: GestureDetector(
              onTap: _isLoading ? null : _verifyOTP, // Disable tap if loading
              child: Container(
                width: 317,
                height: 55,
                decoration: BoxDecoration(
                  color: _isLoading
                      ? Colors.grey
                      : const Color(0xFF61A3FA), // Grey out when loading
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
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
