import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_theme_tool.dart';
import 'input.style.dart';
import 'input.variant.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;

  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final CustomInputShape shape;

  const CustomInput({
    super.key,
    this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.shape = CustomInputShape.rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      style: CustomInputStyle(shape: shape).layout,
      child: Focus(
        child: Builder(
          builder: (context) {
            // 2. 解析文本样式 Spec (注意：现在使用 Style.of(context))
            // 也可以直接 resolve 具体的属性
            final textSpec = TextSpec.of(context);

            return TextField(
              controller: controller,
              obscureText: obscureText,
              cursorColor: context.color(mxt.color.primary),
              // 使用解析后的样式，如果没有定义则回退到默认
              style: textSpec.style,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: sp(16), color: Colors.grey),
                // 3. 使用 StyledIcon，它会自动根据 Style 中的 $icon 定义来渲染
                prefixIcon: StyledIcon(icon, style: CustomInputStyle.iconStyle),
                suffixIcon: suffixIcon,

                border: InputBorder.none,

                contentPadding: EdgeInsets.symmetric(horizontal: w(26),
                  vertical: 18,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
