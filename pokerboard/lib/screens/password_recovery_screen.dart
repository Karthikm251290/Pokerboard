// lib/screens/password_recovery_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  static const routeName = '/passwordRecovery';

  const PasswordRecoveryScreen({super.key});
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController emailController = TextEditingController();

  void _recoverPassword() async {
    await _authService.sendPasswordResetEmail(emailController.text.trim());
    // Show success message
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Recovery'),
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
            // Recover Button
            ElevatedButton(
              onPressed: _recoverPassword,
              child: const Text('Send Recovery Email'),
            ),
          ],
        ),
      ),
    );
  }
}
