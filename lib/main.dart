import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mydoc/login_page.dart';
import 'firebase_options.dart'; // Make sure to import your firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDoc',
      debugShowCheckedModeBanner: false, // Remove the debug banner

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Assuming LoginPage is your login page
    );
  }
}
