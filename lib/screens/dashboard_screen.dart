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
    const String apiUrl = "http://192.168.1.6:5000/api/jobs";
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
    final String walletUrl = "http://192.168.1.6:5000/api/workers/wallet/${widget.worker['id']}";
    try {
      final response = await http.get(Uri.parse(walletUrl));
      print("WALLET API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Parsed wallet_balance: ${data['wallet_balance']}");
        setState(() => _walletBalance = data['wallet_balance']);
      }else {
        _showMessage("Failed to load wallet: ${response.statusCode}");
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
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        var job = _jobs[index];
        String title = job['title'] ?? 'No Title';
        String description = job['description'] ?? 'No Description';
        String budget = job['budget']?.toString() ?? '0';

        return Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(description),
            trailing: Text("₹$budget"),
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
      itemCount: _jobHistory.length,
      itemBuilder: (context, index) {
        var job = _jobHistory[index];
        return Card(
          child: ListTile(
            title: Text(job['job_title']),
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
        onTap: (i) => setState(() => _selectedIndex = i),
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

// 📋 JOB DETAIL SCREEN WITH ACCEPT JOB BUTTON
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

    final acceptUrl = "http://192.168.1.6:5000/api/jobs/accept";
    final walletUrl = "http://192.168.1.6:5000/api/workers/wallet/deduct";

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
    final String title = widget.job['title'] ?? 'No Title';
    final String description = widget.job['description'] ?? 'No Description';
    final String budget = widget.job['budget']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Description:", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(description),
            const SizedBox(height: 10),
            Text("Budget:$budget", style: const TextStyle(fontWeight: FontWeight.bold)),
            //Text(budget),
            const SizedBox(height: 10),
            Text("Type: ${job['worker_type']}"),
            const SizedBox(height: 10),
            Text("City: ${job['city']}"),
            const SizedBox(height: 20),
            _isAccepting
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _acceptJob,
              child: const Text("Accept Job"),
            ),
          ],
        ),
      ),
    );
  }
}
