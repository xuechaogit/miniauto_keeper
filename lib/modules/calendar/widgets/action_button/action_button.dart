import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'action_button.style.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: ActionButtonStyle.layout,
      child: IconButton(
        onPressed: onTap,
        icon: StyledIcon(icon, style: ActionButtonStyle.icon),
      ),
    );
  }
}
