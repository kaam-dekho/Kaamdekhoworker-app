import 'package:flutter/material.dart';
import '../routes/app_routes.dart'; // Import for navigation

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to Login Screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top Blue Section
          Positioned(
            left: -1,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 323,
              decoration: const BoxDecoration(color: Color(0xFF5973A8)),
            ),
          ),

          // Bottom Blue Section
          Positioned(
            left: -1,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width + 10,
              height: 282,
              decoration: const BoxDecoration(color: Color(0xFF5973A8)),
                ),
              ),



          // Background Image
          Positioned(
            left: -2,
            top: 289,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 426,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/413/426"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Center Logo or Image
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            top: 289,
            child: Container(
              width: 246,
              height: 246,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/246/246"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
