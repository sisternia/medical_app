import 'package:flutter/material.dart';
import 'package:medical/auth/forgot_pass_form.dart';
import 'package:medical/auth/login_form.dart';
import 'package:medical/auth/sign_up_form.dart';
import 'package:medical/components/social_button.dart';
import 'package:medical/utils/text.dart';
import '../utils/config.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignIn = true;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/Logo.png',
                height: 75, // Đặt chiều cao tùy ý
                width: 75, // Đặt chiều rộng tùy ý
              ),
              Text(
                AppText.enText['welcome_text']!,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              Text(
                isSignIn
                    ? AppText.enText['signIn_text']!
                    : AppText.enText['register_text']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              isSignIn ? const LoginForm() : const SignUpForm(),
              Config.spaceSmall,
              isSignIn
                  ? Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordForm(),
                            ),
                          );
                        },
                        child: Text(
                          AppText.enText['forgot-password']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const Spacer(),
              Center(
                child: Text(
                  AppText.enText['social-login']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              Config.spaceSmall,
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SocialButton(social: 'google'),
                  SocialButton(social: 'facebook'),
                ],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    isSignIn
                        ? AppText.enText['signUp_text']!
                        : AppText.enText['registered_text']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn ? 'Sign Up' : 'Sign In',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
