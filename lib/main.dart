import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:share_ryde/authentication/authentication.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print('Error at initialization of firebase.');
  }
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
