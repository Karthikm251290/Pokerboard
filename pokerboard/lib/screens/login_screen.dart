// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'password_recovery_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    UserModel? user = await _authService.signIn(
        emailController.text.trim(), passwordController.text.trim());
    if (user != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      // Show error
    }
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  void _navigateToPasswordRecovery() {
    Navigator.pushNamed(context, PasswordRecoveryScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning Poker - Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email TextField
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            // Password TextField
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // Login Button
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            // Sign Up Link
            TextButton(
              onPressed: _navigateToSignUp,
              child: const Text('Don\'t have an account? Sign Up'),
            ),
            // Password Recovery Link
            TextButton(
              onPressed: _navigateToPasswordRecovery,
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
