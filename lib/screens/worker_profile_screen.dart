import 'package:flutter/material.dart';

class WorkerProfileScreen extends StatelessWidget {
  final Map<String, dynamic> worker;

  const WorkerProfileScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture (placeholder for now)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/profile_placeholder.png"),
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Profile Details
              _buildProfileDetail("Name", worker['name'] ?? "N/A"),
              _buildProfileDetail("Date of Birth", worker['dob'] ?? "N/A"),
              _buildProfileDetail("Gender", worker['gender'] ?? "N/A"),
              _buildProfileDetail("Phone Number", worker['phone'] ?? "N/A"),
              _buildProfileDetail("Aadhar Card Number", worker['aadhar'] ?? "N/A"),
              _buildProfileDetail("Skills", (worker['skills'] as List?)?.join(", ") ?? "N/A"),
              _buildProfileDetail("Experience", worker['experience'] ?? "N/A"),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your edit logic later
                  },
                  child: const Text("Edit Profile"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
