import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'login_label.style.dart';

class LoginLabel extends StatelessWidget {
  final String text;
  const LoginLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Box(style: LoginLabelStyle.main, child: StyledText(text));
  }
}
