import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this import
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cjfuunwpatjgelmzzzio.supabase.co', // 👈 Replace with your Supabase project URL
    anonKey: 'yJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqZnV1bndwYXRqZ2VsbXp6emlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQyODgxNTcsImV4cCI6MjA1OTg2NDE1N30.-eY5rb7bBEqU7Cb4DhTqlPZvKyhNmNgm_VTAfSg8XE8', // 👈 Replace with your Supabase anon/public key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KaamDekho Worker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
