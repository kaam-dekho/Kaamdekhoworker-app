import 'package:flutter/material.dart';
import 'package:kaamdekhoworker/screens/profile_screen.dart';

void main() {
  runApp(KaamDekhoWorkerApp());
}

class KaamDekhoWorkerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkerDashboard(),
    );
  }
}

class WorkerDashboard extends StatelessWidget {
  final List<Map<String, String>> jobRequests = [
    {'title': 'Help me move this couch', 'distance': '2.5km', 'by': 'Rahul'},
    {'title': 'I need help assembling my desk', 'distance': '3.2km', 'by': 'Amit'},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Job Requests',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: jobRequests.isNotEmpty
                  ? ListView.builder(
                itemCount: jobRequests.length,
                itemBuilder: (context, index) {
                  final job = jobRequests[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(job['title']!,
                          style: TextStyle(fontSize: 18)),
                      subtitle: Text('by ${job['by']}, ${job['distance']} away'),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text('View Details'),
                      ),
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  'No requests',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: () {}, child: Text('My Jobs')),
                TextButton(onPressed: () {}, child: Text('Job History')),
                TextButton(onPressed: () {}, child: Text('Earnings')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
