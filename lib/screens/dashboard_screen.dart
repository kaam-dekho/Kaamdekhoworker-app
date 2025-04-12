import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kaamdekhoworker/screens/worker_profile_screen.dart';

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
    const String apiUrl = "http://192.168.1.9:5000/api/jobs";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jobs = jsonDecode(response.body);

        List<dynamic> filteredJobs = jobs.where((job) =>
        job['city'] == widget.worker['city'] && job['is_active'] == true).toList();

        List<dynamic> historyJobs = jobs.where((job) =>
        job['accepted_by'] == widget.worker['id'] && job['is_active'] == false).toList();

        setState(() {
          _jobs = filteredJobs;
          _jobHistory = historyJobs;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching jobs")),
      );
    }
  }

  Future<void> _fetchWallet() async {
    final String walletUrl = "http://192.168.1.9:5000/api/workers/wallet/${widget.worker['id']}";
    try {
      final response = await http.get(Uri.parse(walletUrl));
      if (response.statusCode == 200) {
        setState(() => _walletBalance = jsonDecode(response.body)['wallet_balance']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching wallet balance")),
      );
    }
  }

  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkerProfileScreen(worker: widget.worker)),
    );
  }

  Widget _buildJobList() {
    return _jobs.isEmpty
        ? const Center(child: Text("No active jobs available in your city"))
        : ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        var job = _jobs[index];
        return Card(
          child: ListTile(
            title: Text(job['title']),
            subtitle: Text(job['description']),
            trailing: Text("₹${job['budget']}"),
          ),
        );
      },
    );
  }

  Widget _buildJobHistory() {
    return _jobHistory.isEmpty
        ? const Center(child: Text("No job history"))
        : ListView.builder(
      itemCount: _jobHistory.length,
      itemBuilder: (context, index) {
        var job = _jobHistory[index];
        return Card(
          child: ListTile(
            title: Text(job['title']),
            subtitle: Text("Completed | ₹${job['budget']}"),
          ),
        );
      },
    );
  }

  Widget _buildWallet() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Wallet Balance: ₹$_walletBalance", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          if (_walletBalance < 50)
            Column(
              children: [
                const Text("Low Balance! Recharge Now.", style: TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Recharge"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedIndex == 0
          ? _buildJobList()
          : _selectedIndex == 1
          ? _buildJobHistory()
          : _buildWallet(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Job History"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchDashboardData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
