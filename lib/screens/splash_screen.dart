import 'package:flutter/material.dart';
import 'package:instagram/resources/authgate.dart';
import 'package:instagram/screens/login_screen.dart';
// Adjust the import to your actual auth gate or home page

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        Duration(seconds: 5), () {}); // Add a delay for the splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AuthGate()), // Adjust to your auth gate or home page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 246, 244, 245), // You can customize the background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/socapp1.jpg',
              width: 90,
              height: 80,
            ),
            SizedBox(height: 20),
            Text(
              "GRAMHUB",
              style: TextStyle(
                fontSize: 24,
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
