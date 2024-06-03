import 'package:flutter/material.dart';
import 'package:medical/components/button.dart';
import 'package:medical/main.dart';
import 'package:medical/models/auth_model.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import '../utils/config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                hintText: 'Name',
                labelText: 'Name',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.person_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ),
          Config.spaceSmall,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Config.primaryColor,
              decoration: const InputDecoration(
                hintText: 'Email Address',
                labelText: 'Email',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Config.primaryColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(r'^[^@]+@(gmail\.com|vku\.udn\.vn)$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onChanged: (value) {
                if (_errorMessage.isNotEmpty) {
                  setState(() {
                    _errorMessage = '';
                  });
                }
              },
            ),
          ),
          Config.spaceSmall,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _passController,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Config.primaryColor,
              obscureText: obsecurePass,
              decoration: InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obsecurePass = !obsecurePass;
                    });
                  },
                  icon: obsecurePass
                      ? const Icon(
                          Icons.visibility_off_outlined,
                          color: Colors.black38,
                        )
                      : const Icon(
                          Icons.visibility_outlined,
                          color: Config.primaryColor,
                        ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          Config.spaceSmall,
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final result = await DioProvider().registerUser(
                        _nameController.text,
                        _emailController.text,
                        _passController.text);

                    if (result == 'success') {
                      final token = await DioProvider().getToken(
                          _emailController.text, _passController.text);

                      if (token) {
                        auth.loginSuccess({}, {});
                        // Chuyển hướng đến màn hình đăng nhập
                        MyApp.navigatorKey.currentState!.pushNamed('/');
                      }
                    } else {
                      setState(() {
                        _errorMessage = result;
                      });
                    }
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}
