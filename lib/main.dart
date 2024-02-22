import 'package:flutter/material.dart';
import 'package:share_ryde/authentication/authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Share Ryde',
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}
