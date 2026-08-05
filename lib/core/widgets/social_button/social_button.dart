import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import 'social_button.style.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: onTap,
      child: Box(
        style: SocialButtonStyle.main,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: r(32)),
            SizedBox(width: w(10)),
            StyledText(label, style: SocialButtonStyle.labelStyle),
          ],
        ),
      ),
    );
  }
}
