import 'package:flutter/material.dart';
import 'package:medical/utils/config.dart';
import 'package:medical/utils/text.dart';
import 'package:medical/components/button.dart'; // Import the Button component
import 'package:medical/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isEmailValid = false;
  bool _showNewPasswordField = false;

  Future<void> _validateEmail() async {
    final email = _emailController.text;
    final token = await DioProvider().getToken(email, '');

    if (token != false) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final tokenValue = prefs.getString('token') ?? '';

      if (tokenValue.isNotEmpty && tokenValue != '') {
        final response = await DioProvider().getUser(tokenValue);

        if (response != null) {
          setState(() {
            _isEmailValid = true;
            _showNewPasswordField = true;
          });
        }
      }
    } else {
      setState(() {
        _isEmailValid = false;
        _showNewPasswordField = false;
      });
    }
  }

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
            if (!_isEmailValid)
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            if (_showNewPasswordField) ...[
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Config.spaceMedium,
            ],
            Config.spaceBig,
            Button(
              width: double.infinity,
              title: _showNewPasswordField
                  ? (AppText.enText['update-password-button'] ??
                      'Update Password')
                  : (AppText.enText['reset-password-button'] ??
                      'Reset Password'),
              onPressed: () {
                if (_showNewPasswordField) {
                  // Logic to update the password
                } else {
                  _validateEmail();
                }
              },
              disable: false,
            ),
          ],
        ),
      ),
    );
  }
}
