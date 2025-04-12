import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Replace these with your actual screen imports
import 'package:kaamdekhoworker/screens/dashboard_screen.dart';
import 'package:kaamdekhoworker/screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _generatedOTP;
  String? _message;

  // Generate random 6-digit OTP
  void _sendOTP() {
    final random = Random();
    setState(() {
      _generatedOTP = (100000 + random.nextInt(900000)).toString();
      _message = 'OTP sent (for testing): $_generatedOTP';
    });
  }

  // Verify OTP
  void _verifyOTP() async {
    if (_otpController.text.trim() == _generatedOTP) {
      print("OTP verified correctly");
      await _verifyWithBackend();
    } else {
      setState(() {
        _message = 'Invalid OTP. Please try again.';
      });
    }
  }

  // Verify with backend
  Future<void> _verifyWithBackend() async {
    final phone = _phoneController.text.trim();
    final url = Uri.parse('http://192.168.1.9:5000/api/auth/login');
    print("Calling backend...");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isNew = data['isNew'] ?? false;
        final workerData = data['worker'] ;
        print(workerData);
        final Id = workerData['id'];
        print("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        print(Id);
        if (isNew) {
          print("new User");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(phone:  _phoneController.text.trim(),workerId: Id,)) // 👈 worker ID passed here)),
          );
        } else {
          print("existing User");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(worker: workerData,)),
          );
        }
      } else {
        setState(() {
          _message = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Something went wrong. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'lib/assets/images/icon.png',
                  height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  'KaamDekho Worker',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Phone number field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _sendOTP,
                  child: const Text('Send OTP'),
                ),

                const SizedBox(height: 16),

                // OTP field
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  child: const Text('Verify OTP'),
                ),

                const SizedBox(height: 24),

                if (_message != null)
                  Text(
                    _message!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
