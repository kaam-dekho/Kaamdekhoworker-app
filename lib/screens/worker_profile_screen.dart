import 'package:flutter/material.dart';
import 'package:kaamdekhoworker/screens/profile_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profile_placeholder.png"), // Replace with actual image
              ),
            ),
            const SizedBox(height: 20),

            // Personal Details
            _buildProfileDetail("Name", "Rahul Sharma"),
            _buildProfileDetail("Date of Birth", "12-08-1995"),
            _buildProfileDetail("Gender", "Male"),
            _buildProfileDetail("Phone Number", "+91 9876543210"),
            _buildProfileDetail("Aadhar Card Number", "XXXX-XXXX-XXXX"),
            _buildProfileDetail("Skills", "Electrician, Plumber"),
            _buildProfileDetail("Experience", "5 years"),
            const SizedBox(height: 20),

            // Edit Profile Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Profile Registration to update details
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: const Text("Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
