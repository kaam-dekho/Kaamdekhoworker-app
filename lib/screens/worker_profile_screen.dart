import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaamdekhoworker/screens/profile_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  final Map<String, dynamic> worker;

  const WorkerProfileScreen({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage("lib/assets/profile_placeholder.png"),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      worker['name'] ?? "Unnamed",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(worker['worker_type'] ?? "Skill not available"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildInfoCard(icon: FontAwesomeIcons.calendarAlt, title: "Date of Birth", value: worker['worker_dob']),
            _buildInfoCard(icon: FontAwesomeIcons.genderless, title: "Gender", value: worker['gender']),
            _buildInfoCard(icon: FontAwesomeIcons.phone, title: "Phone Number", value: worker['phone']),
            _buildInfoCard(icon: FontAwesomeIcons.idCard, title: "Aadhar Card", value: worker['aadhaar_number']),
            _buildInfoCard(icon: FontAwesomeIcons.briefcase, title: "Experience", value: worker['experience']),
            _buildInfoCard(icon: FontAwesomeIcons.city, title: "City", value: worker['city']),
            _buildInfoCard(icon: FontAwesomeIcons.toolbox, title: "Skills", value: worker['worker_type']),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      phone: worker['phone'],
                      workerId: worker['id'].toString(), // in case it's not already a string
                    ),
                  ),
                );
                // TODO: Add edit functionality
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, String? value}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? "N/A", style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
