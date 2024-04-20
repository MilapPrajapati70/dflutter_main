import 'package:dflutter_main/CreateAccountScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'LoginScreen.dart';
import 'MyHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCWQ3Y1dfEaux8eRZfJn88z9pHCnT-SHO8",
      appId: "1:199046187795:android:03924f03aefff7310728e6",
      messagingSenderId: "199046187795",
      projectId: "groupproject-c3499",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser != null ? const MyHomePage(title: "Job Search") : const LoginScreen(),
    );
  }
}
