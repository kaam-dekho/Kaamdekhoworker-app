import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:kaamdekhoworker/screens/dashboard_screen.dart';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  final String phone;
  final String workerId;


  const ProfileScreen({super.key, required this.phone, required this.workerId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  DateTime? selectedDOB;
  String? selectedGender;
  String? selectedCity;
  File? profilePhoto;
  File? aadharPhoto;
  //String? workerId;

  final List<String> cities = ['Mumbai', 'Delhi', 'Bengaluru', 'Hyderabad', 'Kolkata', 'Chennai', 'Jaipur', 'Hyderabad'];

  // Pick image
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

  bool isValidAge(DateTime dob) {
    final now = DateTime.now();
    final age = now.year - dob.year;
    return age > 18 || (age == 18 && (now.month > dob.month || (now.month == dob.month && now.day >= dob.day)));
  }

  Future<void> selectDOB(BuildContext context) async {
    final picked = await showDatePicker(
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

  Future<void> fetchWorkerId() async {
    try {
      final uri = Uri.parse("https://kaamdekho-backend-worker.onrender.com/api/workers/profile/${widget.workerId}");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //workerId = data['id'];
      } else {
        throw Exception('Failed to fetch worker ID');
      }
    } catch (e) {
      print("Fetch Error: $e");
    }
  }

  Future<void> submitForm() async {
    if (nameController.text.isEmpty ||
        selectedDOB == null ||
        selectedGender == null ||
        selectedCity == null ||
        skillsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields (excluding photos for now)!")),
      );
      return;
    }

    await fetchWorkerId();
    print("*****************************************************************************************************************************");

    if (widget.workerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to retrieve worker ID")),
      );
      return;
    }

    try {
      var uri = Uri.parse("https://kaamdekho-backend-worker.onrender.com/api/workers/profile/${widget.workerId}");

      final body = json.encode({
        "name": nameController.text,
        "worker_dob": selectedDOB!.toIso8601String(),
        "gender": selectedGender!,
        "worker_type": skillsController.text,
        "city": selectedCity!,
        "phone": widget.phone,
      });

      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print("Using worker ID: ${widget.workerId}");

      if (response.statusCode == 200) {
        final workerData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile submitted successfully!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(worker:  workerData)),
        );
      } else {
        print("Failed response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit: ${response.statusCode}\n${response.body}")),
        );
      }
    } catch (e) {
      print("Submit Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () => selectDOB(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    selectedDOB == null
                        ? "Select Date"
                        : "${selectedDOB!.day}/${selectedDOB!.month}/${selectedDOB!.year}",
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ["Male", "Female", "Other"].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (val) => setState(() => selectedGender = val),
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCity,
                items: cities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (val) => setState(() => selectedCity = val),
                decoration: InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: skillsController,
                decoration: InputDecoration(
                  labelText: "Worker Type (e.g. Plumber, Electrician)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 15),
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
                      ? const Center(child: Text("Tap to upload Aadhaar Card Photo"))
                      : Image.file(aadharPhoto!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Center(
                  child: Text("Submit", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}