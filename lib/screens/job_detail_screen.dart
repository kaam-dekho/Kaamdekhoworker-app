import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final Map<String, dynamic> worker;
  final int walletBalance;
  final VoidCallback onJobAccepted;

  const JobDetailScreen({
    super.key,
    required this.job,
    required this.worker,
    required this.walletBalance,
    required this.onJobAccepted,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isAccepting = false;

  Future<void> _acceptJob() async {
    if (widget.walletBalance < 5) {
      _showMessage("Low balance! Cannot accept job.");
      return;
    }

    setState(() => _isAccepting = true);

    final acceptUrl = "https://kaamdekho-backend-worker.onrender.com/api/jobs/accept";
    final walletUrl = "https://kaamdekho-backend-worker.onrender.com/api/workers/wallet/deduct";

    try {
      final walletResponse = await http.post(
        Uri.parse(walletUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "worker_id": widget.worker['id'],
          "amount": 5,
        }),
      );

      if (walletResponse.statusCode != 200) {
        _showMessage("Wallet deduction failed");
        setState(() => _isAccepting = false);
        return;
      }

      final acceptResponse = await http.post(
        Uri.parse(acceptUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "job_id": widget.job['id'],
          "worker_phone": widget.worker['phone'],
        }),
      );

      if (acceptResponse.statusCode == 200) {
        _showMessage("Job Accepted!");
        widget.onJobAccepted();
        Navigator.pop(context);
      } else {
        _showMessage("Failed to accept job");
      }
    } catch (e) {
      _showMessage("Error occurred while accepting job");
    }

    setState(() => _isAccepting = false);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(
                    FontAwesomeIcons.briefcase,
                    size: 40,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    job['title'] ?? 'No Title',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 30, thickness: 1.5),
                InfoRow(icon: Icons.description, label: "Description", value: job['description'] ?? "Not provided"),
                const SizedBox(height: 10),
                InfoRow(icon: Icons.money, label: "Budget", value: "₹${job['budget'] ?? '0'}"),
                const SizedBox(height: 10),
                InfoRow(icon: Icons.category, label: "Type", value: job['worker_type'] ?? "N/A"),
                const SizedBox(height: 10),
                InfoRow(icon: Icons.location_on, label: "City", value: job['city'] ?? "N/A"),
                const SizedBox(height: 20),
                _isAccepting
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _acceptJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("Accept Job", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label: $value",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
