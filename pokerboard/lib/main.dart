// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '/screens/login_screen.dart';
import 'screens/signup_screen.dart';
import '/screens/password_recovery_screen.dart';
import '/screens/home_screen.dart';
import '/screens/room_screen.dart';
import '/screens/story_screen.dart';
import 'package:provider/provider.dart';
import '/services/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(PlanningPokerApp());
}

class PlanningPokerApp extends StatelessWidget {
  const PlanningPokerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planning Poker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        PasswordRecoveryScreen.routeName: (context) => PasswordRecoveryScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        RoomScreen.routeName: (context) => room_Screen(),
        StoryScreen.routeName: (context) => StoryScreen(),
      },
    );
  }
}
