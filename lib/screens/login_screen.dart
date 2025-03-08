import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../routes/app_routes.dart'; // Import for navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String generatedOTP = "";

  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    super.initState();
    // Initialize Twilio
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
      authToken: 'YOUR_TWILIO_AUTH_TOKEN',
      twilioNumber: 'whatsapp:+14155238886', // Twilio WhatsApp Sandbox Number
    );
  }

  // Generate a random 6-digit OTP
  String generateOTP() {
    return (100000 + (999999 - 100000) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt().toString();
  }

  // Send OTP via WhatsApp
  void sendOTP() {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your phone number!")));
      return;
    }

    generatedOTP = generateOTP();

    twilioFlutter.sendSMS(
      toNumber: 'whatsapp:$phoneNumber', // User's WhatsApp number
      messageBody: 'Your OTP code is: $generatedOTP',
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP sent via WhatsApp!")));
  }

  // Verify OTP
  void verifyOTP() {
    if (otpController.text.trim() == generatedOTP) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Blue Section
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              decoration: const BoxDecoration(color: Color(0xFF5973A8)),
            ),
          ),

          // Bottom Blue Section
          Positioned(
            left: -14,
            bottom: -24,
            child: Container(
              width: MediaQuery.of(context).size.width + 20,
              height: 125,
              decoration: ShapeDecoration(
                color: const Color(0xFF5973A8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00),
                ),
              ),
            ),
          ),

          // Login Box
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('lib/assets/images/icon.png'),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Phone Number Field
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Enter Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),

                  // OTP Field
                  TextField(
                    controller: otpController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5973A8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Generate OTP Button
                  SizedBox(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5973A8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Generate OTP",
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
