import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GynecBandApp());
}

class GynecBandApp extends StatelessWidget {
  const GynecBandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gynec Band",
      theme: ThemeData(
        primaryColor: const Color(0xFFFF2D7A),
        scaffoldBackgroundColor: const Color(0xFFFFF4F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF2D7A),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
