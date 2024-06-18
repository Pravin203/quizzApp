import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quikapp/domain/firebase_service/firebase_service.dart';
import 'package:quikapp/ui_library/app_theme.dart';
import 'package:quikapp/ui_library/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // User is logged in
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user != null) {
          bool userExists =
              await _firebaseService.checkIfUserExistsInDatabase(user.uid);
          if (userExists) {
            bool registrationCompleted =
                await _firebaseService.checkIfUserExistsInDatabase(user.uid);
            if (registrationCompleted) {
              // User is registered and completed registration
              _navigateToScreen('/dashboard');
            } else {
              // User is registered but not completed registration
              _navigateToScreen('/registrationScreen');
            }
          } else {
            // User does not exist in the database
            _navigateToScreen('/registrationScreen');
          }
        }
      });
    }
  }

  void _navigateToScreen(String routeName) {
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(child: SvgPicture.asset('assets/Logo.svg')),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, left: 24, right: 24),
              child: Visibility(
                visible: FirebaseAuth.instance.currentUser == null,
                child: Button(
                  text: 'Get Start',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  variant: ButtonVariant.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
