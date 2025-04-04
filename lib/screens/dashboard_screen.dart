import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Position? _currentPosition;
  List<dynamic> _nearbyJobs = [];
  bool _isLoading = true;
  bool _errorOccurred = false;
  int _selectedIndex = 0; // For bottom navigation

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage("Please enable location services");
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          _showMessage("Location permissions are permanently denied");
          setState(() => _isLoading = false);
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });

      await _fetchJobs();
    } catch (e) {
      _showMessage("Failed to get location");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchJobs() async {
    if (_currentPosition == null) return;

    const String apiUrl = "https://yourbackend.com/api/jobs"; // Replace with actual API

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jobs = jsonDecode(response.body);

        List<dynamic> nearbyJobs = jobs.where((job) {
          double jobLat = job["latitude"];
          double jobLng = job["longitude"];
          return _calculateDistance(
              _currentPosition!.latitude, _currentPosition!.longitude, jobLat, jobLng) <=
              5;
        }).toList();

        setState(() {
          _nearbyJobs = nearbyJobs;
          _isLoading = false;
          _errorOccurred = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorOccurred = true;
        });
        _showMessage("Failed to fetch jobs");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorOccurred = true;
      });
      _showMessage("Failed to connect to server");
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371;
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, "/profile"); // Replace with actual route
  }

  Widget _buildJobList() {
    return _nearbyJobs.isEmpty
        ? const Center(child: Text("No nearby jobs available"))
        : ListView.builder(
      itemCount: _nearbyJobs.length,
      itemBuilder: (context, index) {
        var job = _nearbyJobs[index];
        return Card(
          child: ListTile(
            title: Text(job["description"]),
            subtitle: Text(
                "Distance: ${_calculateDistance(_currentPosition!.latitude, _currentPosition!.longitude, job["latitude"], job["longitude"]).toStringAsFixed(2)} km"),
            trailing: Text(job["workerTag"]),
          ),
        );
      },
    );
  }

  Widget _buildJobHistory() {
    return const Center(child: Text("Job History will be shown here"));
  }

  Widget _buildWallet() {
    return const Center(child: Text("Wallet Balance: ₹0"));
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
          : _errorOccurred
          ? const Center(child: Text("Error fetching jobs"))
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
        onPressed: _fetchJobs,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
