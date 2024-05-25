import 'package:flutter/material.dart';
import 'package:medical/utils/config.dart';
import 'package:medical/utils/text.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppText.enText['forgot-password-instruction'] ??
                  'Please enter your email address to reset your password.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Config.spaceBig,
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Config.spaceBig,
            ElevatedButton(
              onPressed: () {
                // Logic to handle forgot password
              },
              child: Text(
                  AppText.enText['reset-password-button'] ?? 'Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
