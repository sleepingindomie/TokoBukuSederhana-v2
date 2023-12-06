import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tokobukusederhana/screens/SplashScreen.dart';


FirebaseApp? app;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyAEl_1xxJRTKjkAsP7qdVG7mGeuJh_JpQU",
      appId: "1:1031918041875:android:ec3b06e62f4053ef6d78e6",
      messagingSenderId: "Messaging sender id here",
      projectId: "tokobukusederhana-a4538",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Buku Sederhana',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 145, 0)),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

