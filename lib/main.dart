// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'requirement/login_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase(); // Initialize Firebase
  runApp(MyApp());
}

// Function to initialize Firebase
Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false; // State for dark theme

  // Method to toggle theme
  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: AuthWrapper(toggleTheme: toggleTheme, isDarkTheme: isDarkTheme),
    );
  }
}

// AuthWrapper class to handle authentication state
class AuthWrapper extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkTheme;

  AuthWrapper({required this.toggleTheme, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text("Something went wrong")); // Error message
        } else if (snapshot.hasData) {
          // User is logged in
          return HomeScreen(
            toggleTheme: toggleTheme,
            isDarkTheme: isDarkTheme,
          );
        } else {
          // User is not logged in
          return LoginScreen(
            toggleTheme: toggleTheme, // Pass toggleTheme to LoginScreen
            isDarkTheme: isDarkTheme, // Pass isDarkTheme to LoginScreen
          );
        }
      },
    );
  }
}
