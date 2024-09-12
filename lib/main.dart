import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/AddCat.dart';
import 'package:test/Login.dart';
import 'package:test/Regester.dart';
import 'package:test/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: {
        '/screen2': (context) => const MYSCR1(),
        '/screen1': (context) => const MYSCR2(),
        '/home': (context) => const Home(),
        '/Addcat': (context) => const Addcat(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Something went wrong!')),
          );
        } else if (snapshot.hasData) {
          // User is logged in
          return const Home();
        } else {
          // User is not logged in
          return const MYSCR1(); // This should be your login screen
        }
      },
    );
  }
}
