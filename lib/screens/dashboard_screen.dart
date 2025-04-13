import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaamdekhoworker/screens/worker_profile_screen.dart';
import 'package:kaamdekhoworker/screens/job_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> worker;

  const DashboardScreen({super.key, required this.worker});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _jobs = [];
  List<dynamic> _jobHistory = [];
  bool _isLoading = true;
  int _selectedIndex = 0;
  int _walletBalance = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);
    await _fetchJobs();
    await _fetchWallet();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchJobs() async {
    const String apiUrl = "https://kaamdekho-backend-worker.onrender.com/api/jobs";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jobs = jsonDecode(response.body);
        List<dynamic> filteredJobs = jobs.where((job) =>
        job['city'] == widget.worker['city'] && job['status'] == 'pending').toList();

        List<dynamic> historyJobs = jobs.where((job) =>
        job['accepted_by'] == widget.worker['phone'] && job['status'] != 'pending').toList();

        setState(() {
          _jobs = filteredJobs;
          _jobHistory = historyJobs;
        });
      }
    } catch (e) {
      _showMessage("Error fetching jobs");
    }
  }

  Future<void> _fetchWallet() async {
    final String walletUrl = "https://kaamdekho-backend-worker.onrender.com/api/workers/wallet/${widget.worker['id']}";
    try {
      final response = await http.get(Uri.parse(walletUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => _walletBalance = data['wallet_balance']);
      } else {
        _showMessage("Failed to load wallet: \${response.statusCode}");
      }
    } catch (e) {
      _showMessage("Error fetching wallet balance");
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkerProfileScreen(worker: widget.worker)),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildJobList() {
    return _jobs.isEmpty
        ? const Center(child: Text("No active jobs available in your city"))
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        var job = _jobs[index];
        String title = job['title'] ?? 'No Title';
        String description = job['description'] ?? 'No Description';
        String budget = job['budget']?.toString() ?? '0';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          color: Colors.indigo[50],
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(Icons.work, color: Colors.white),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            trailing: Chip(label: Text("₹$budget", style: const TextStyle(color: Colors.white)), backgroundColor: Colors.indigo),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailScreen(
                    job: job,
                    worker: widget.worker,
                    walletBalance: _walletBalance,
                    onJobAccepted: _fetchDashboardData,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildJobHistory() {
    return _jobHistory.isEmpty
        ? const Center(child: Text("No job history"))
        : ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _jobHistory.length,
      itemBuilder: (context, index) {
        var job = _jobHistory[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          color: Colors.green[50],
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            ),
            title: Text(job['title'] ?? 'Job Title', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              "${job['status'].toString().toUpperCase()} | ₹${job['budget']}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }


  Widget _buildWallet() {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 6,
        color: Colors.orange[50],
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_balance_wallet, size: 50, color: Colors.deepOrange),
              const SizedBox(height: 12),
              Text("Wallet Balance: ₹$_walletBalance", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (_walletBalance < 50)
                Column(
                  children: [
                    const Text("Low Balance! Recharge Now.", style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                      child: const Text("Recharge"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedIndex == 0
            ? _buildJobList()
            : _selectedIndex == 1
            ? _buildJobHistory()
            : _buildWallet(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Job History"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _fetchDashboardData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}