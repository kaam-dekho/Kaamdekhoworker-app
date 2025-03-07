import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // Import for navigation

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
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
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width + 20,
              height: 245,
              decoration: ShapeDecoration(
                color: const Color(0xFF5973A8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
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
                    radius: 50,
                    backgroundImage:
                    NetworkImage("https://picsum.photos/195/195"),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    "USER LOGIN",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
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

                  // Social Login Text
                  const Text("Login using", style: TextStyle(fontSize: 16)),

                  // Social Login Button (Google)
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () {
                      // Implement Google Login
                    },
                    icon: const Icon(Icons.account_circle, size: 40),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
