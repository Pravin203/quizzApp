import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quikapp/domain/firebase_options.dart';
import 'package:quikapp/presentation/registartion_screen/regisatrion_screen.dart';

import 'presentation/home_screen/home_screen.dart';
import 'presentation/login_screen/login_screen.dart';
import 'presentation/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure the binding is initialized before Firebase is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(salectedIndex: 0),
        '/registrationScreen': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const HomeScreen(),

      },
      // home: DashboardScreen(),
    ));
  }
}
