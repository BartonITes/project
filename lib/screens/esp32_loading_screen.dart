import 'package:flutter/material.dart';

class Esp32LoadingScreen extends StatelessWidget {
  const Esp32LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
