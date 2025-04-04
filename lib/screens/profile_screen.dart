import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  DateTime? selectedDOB;
  String? selectedGender;
  File? profilePhoto;
  File? aadharPhoto;

  // Function to pick an image from gallery or camera
  Future<void> pickImage(ImageSource source, bool isProfilePhoto) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isProfilePhoto) {
          profilePhoto = File(pickedFile.path);
        } else {
          aadharPhoto = File(pickedFile.path);
        }
      });
    }
  }

  // Function to validate age (must be 18+)
  bool isValidAge(DateTime dob) {
    final now = DateTime.now();
    final age = now.year - dob.year;
    return age > 18 || (age == 18 && (now.month > dob.month || (now.month == dob.month && now.day >= dob.day)));
  }

  // Function to select DOB
  Future<void> selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
    );
    if (picked != null && isValidAge(picked)) {
      setState(() {
        selectedDOB = picked;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must be at least 18 years old!")),
      );
    }
  }

  // Function to submit form
  void submitForm() {
    if (nameController.text.isEmpty ||
        selectedDOB == null ||
        selectedGender == null ||
        skillsController.text.isEmpty ||
        experienceController.text.isEmpty ||
        profilePhoto == null ||
        aadharPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and upload photos!")),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // Date of Birth (with Calendar Picker)
              InkWell(
                onTap: () => selectDOB(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    selectedDOB == null ? "Select Date" : "${selectedDOB!.day}/${selectedDOB!.month}/${selectedDOB!.year}",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ["Male", "Female", "Other"].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender, style: GoogleFonts.poppins(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // Skills
              TextField(
                controller: skillsController,
                decoration: InputDecoration(
                  labelText: "Skills (e.g. Plumber, Electrician)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // Experience
              TextField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Experience (in years)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),

              // Upload Profile Photo
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery, true),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: profilePhoto == null
                      ? const Center(child: Text("Tap to upload Profile Photo"))
                      : Image.file(profilePhoto!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 15),

              // Upload Aadhar Card Photo
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery, false),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: aadharPhoto == null
                      ? const Center(child: Text("Tap to upload Aadhar Card Photo"))
                      : Image.file(aadharPhoto!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 15),

              // Submit Button
              ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Center(child: Text("Submit", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
