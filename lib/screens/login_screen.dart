import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void _sendOTP() {
    final random = Random();
    setState(() {
      _generatedOTP = (100000 + random.nextInt(900000)).toString();
      _message = 'OTP sent (for testing): $_generatedOTP';
    });
  }

  void _verifyOTP() async {
    if (_otpController.text.trim() == _generatedOTP) {
      await _verifyWithBackend();
    } else {
      setState(() {
        _message = 'Invalid OTP. Please try again.';
      });
    }
  }

  Future<void> _verifyWithBackend() async {
    final phone = _phoneController.text.trim();
    final url = Uri.parse('https://kaamdekho-backend-worker.onrender.com/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isNew = data['isNew'] ?? false;
        final workerData = data['worker'];
        final Id = workerData['id'];

        if (isNew) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                phone: _phoneController.text.trim(),
                workerId: Id,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(worker: workerData),
            ),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'lib/assets/images/icon.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'KaamDekho Worker',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1e3c72),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 28),

                  // Phone input
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Enter Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendOTP,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color(0xFF1e3c72),
                      ),
                      child: const Text('Send OTP'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // OTP input
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color(0xFF1e3c72),
                      ),
                      child: const Text('Verify OTP'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_message != null)
                    Text(
                      _message!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
