import 'package:flutter/material.dart';

class WorkerProfileScreen extends StatefulWidget {
  const WorkerProfileScreen({super.key}); // Added const constructor

  @override
  _WorkerProfileScreenState createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends State<WorkerProfileScreen> {
  bool isDarkMode = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String gender = 'Male';
  Map<String, bool> selectedSkills = {
    'Plumbing': false,
    'Electrician': false,
    'Carpentry': false,
    'Painting': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: aadharController,
              decoration: const InputDecoration(labelText: 'Aadhar Number'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            const Text('Select Skills', style: TextStyle(fontSize: 18)),
            Column(
              children: selectedSkills.keys.map((skill) {
                return CheckboxListTile(
                  title: Text(skill),
                  value: selectedSkills[skill],
                  onChanged: (value) {
                    setState(() {
                      selectedSkills[skill] = value!;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save Profile Data
              },
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
