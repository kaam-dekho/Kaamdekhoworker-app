import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:5000/api/workers"; // Change this to your API URL

  // ✅ Worker Registration API
  static Future<Map<String, dynamic>> registerWorker(Map<String, dynamic> workerData) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(workerData),
    );

    return jsonDecode(response.body);
  }

  // ✅ Fetch Job List API
  static Future<List<dynamic>> getJobs() async {
    final url = Uri.parse('$baseUrl/jobs');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["jobs"];
    } else {
      throw Exception("Failed to load jobs");
    }
  }

  // ✅ Accept Job API
  static Future<Map<String, dynamic>> acceptJob(int workerId, int jobId) async {
    final url = Uri.parse('$baseUrl/accept-job');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"worker_id": workerId, "job_id": jobId}),
    );

    return jsonDecode(response.body);
  }

  // ✅ Complete Job API
  static Future<Map<String, dynamic>> completeJob(int workerId, int jobId) async {
    final url = Uri.parse('$baseUrl/complete-job');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"worker_id": workerId, "job_id": jobId}),
    );

    return jsonDecode(response.body);
  }
}
