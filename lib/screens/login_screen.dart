import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'worker_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String generatedOTP = "";
  String visibleOTP = "";

  // Generate a 6-digit OTP
  String generateOTP() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Fake OTP sending (for testing)
  void sendOTP() {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty || !RegExp(r'^[0-9]{10,15}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid phone number!")),
      );
      return;
    }

    generatedOTP = generateOTP();
    visibleOTP = generatedOTP;
    print("Generated OTP: $generatedOTP");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP generated! Check console: $generatedOTP")),
    );

    setState(() {});
  }

  // Verify OTP and call backend login
  void verifyOTP() async {
    String enteredOTP = otpController.text.trim();
    String phone = phoneController.text.trim();

    if (enteredOTP.isEmpty || enteredOTP != generatedOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP! Please try again.")),
      );
      return;
    }

    try {
      final url = Uri.parse("http://172.16.58.93:5000/api/auth/login"); // Replace with actual IP
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerProfileScreen(worker: result['worker']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Try again.")),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to server.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset('lib/assets/images/icon.png', height: 120),
              const SizedBox(height: 10),
              Text(
                "KaamDekho Worker",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 5),
              Text("Login to continue", style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 40),

              // Phone input
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: "Enter Phone Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Send OTP", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 20),

              // OTP input
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),

              // Show OTP (for testing)
              if (visibleOTP.isNotEmpty)
                Text(
                  "Generated OTP (for testing): $visibleOTP",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Verify OTP", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
