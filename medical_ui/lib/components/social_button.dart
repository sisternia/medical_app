import 'package:flutter/material.dart';
import '../utils/config.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.social});

  final String social;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        side: const BorderSide(width: 0, color: Colors.white),
      ),
      onPressed: () {},
      child: SizedBox(
        width: Config.widthSize * 0.2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/images/$social.png',
              width: 40,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
