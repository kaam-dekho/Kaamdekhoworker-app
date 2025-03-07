import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // Import for navigation

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                  // App Logo or Icon
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage:
                    AssetImage('lib/assets/images/icon.png'),
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

                  // Phone Numbers Field
                  TextField(
                    controller: emailController,
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

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                      keyboardType: TextInputType.phone
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Dashboard on successful login
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.dashboard);
                      },
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

// generate otp buttom
                  SizedBox(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        // logic to generate otp

                      },
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
                  const SizedBox(height: 20,),




                  // Social Login Button (Google)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
