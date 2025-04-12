import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://172.20.10.2:5000'; // Localhost for Android emulator

class ApiService {
  static Future<Map<String, dynamic>> workerLogin(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> updateWorkerProfile(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/workers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  static Future<void> postJob(Map<String, dynamic> jobData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to post job');
    }
  }

  static Future<List<dynamic>> fetchJobs(String city, String workerType) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/jobs?city=$city&worker_type=$workerType'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  static Future<void> acceptJob(int jobId, int workerId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/jobs/$jobId/accept'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'worker_id': workerId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to accept job');
    }
  }

  static Future<List<dynamic>> getJobHistory(int workerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/workers/$workerId/job-history'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch job history');
    }
  }

  static Future<int> getWalletBalance(int workerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/workers/$workerId/wallet'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['balance'];
    } else {
      throw Exception('Failed to fetch wallet');
    }
  }
}
