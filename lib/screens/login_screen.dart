import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String generatedOTP = "";

  // Generate a secure random 6-digit OTP
  String generateOTP() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Generate OTP and print it to the console
  void sendOTP() {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your phone number!")));
      return;
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter a valid phone number!")));
      return;
    }

    generatedOTP = generateOTP();
    print("Generated OTP: $generatedOTP");

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP generated! Check console.")));
  }

  // Verify OTP
  void verifyOTP() {
    String enteredOTP = otpController.text.trim();

    if (enteredOTP.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP!")),
      );
      return;
    }

    if (enteredOTP == generatedOTP) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP! Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Image.asset('lib/assets/images/icon.png', height: 120),
            const SizedBox(height: 10),

            // App Title
            Text(
              "KaamDekho Worker",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 5),
            Text(
              "Login to continue",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // Phone Number Field
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

            // Send OTP Button
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

            // OTP Input Field
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: "Enter OTP",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Verify OTP Button
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
    );
  }
}
