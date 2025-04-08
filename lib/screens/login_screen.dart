import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kaamdekhoworker/screens/profile_screen.dart';
import 'package:kaamdekhoworker/screens/worker_profile_screen.dart';

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
  Map<String, dynamic>? loginResponse;

  // Generate a secure random 6-digit OTP
  String generateOTP() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Send OTP and make backend call
  Future<void> sendOTP() async {
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
    visibleOTP = generatedOTP;

    // Call backend login API
    try {
      final response = await http.post(
        Uri.parse("http://172.16.58.93:5000/api/auth/login"), // Replace with your IP
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );

      if (response.statusCode == 200) {
        setState(() {
          loginResponse = jsonDecode(response.body);
        });
        print("Generated OTP: $generatedOTP");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP generated! Check console: $generatedOTP")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Try again.")),
        );
      }
    } catch (e) {
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Check connection.")),
      );
    }
  }

  // Verify OTP and Navigate
  void verifyOTP() {
    String enteredOTP = otpController.text.trim();

    if (enteredOTP.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP!")),
      );
      return;
    }

    if (enteredOTP == generatedOTP && loginResponse != null) {
      bool isNew = loginResponse!['newUser'] ?? false;
      var workerData = loginResponse!['worker'];

      if (isNew) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(worker: workerData),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerProfileScreen(worker: workerData),
          ),
        );
      }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset('lib/assets/images/icon.png', height: 120),
              const SizedBox(height: 10),
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

              // Phone Number
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

              if (visibleOTP.isNotEmpty)
                Text("Generated OTP (testing): $visibleOTP",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),

              const SizedBox(height: 20),

              // OTP Field
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

              ElevatedButton(
                onPressed: verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Verify OTP", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
