import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_theme_tool.dart';
import 'login_input.style.dart';

class LoginInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final Widget? suffixIcon;

  const LoginInput({
    super.key,
    this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: const Color(0xFFE52E1D),
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          // 💡 关键：必须设为 true
          filled: true,
          // 使用 context 扩展引用 Token
          fillColor: context.color(mxt.color.surfaceVariant),
          // 3. 使用 Token 圆角
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(context.radius(mxt.radius.medium)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, size: 22),
          suffixIcon: suffixIcon,
          // 4. 使用 Token 间距
          contentPadding: EdgeInsets.all(context.space(mxt.space.medium)),
        ),
      ),
    );
  }
}
