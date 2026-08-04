import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

import 'submit_button.styles.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final RxBool isLoading;
  final VoidCallback onPressed;
  final IconData? icon;

  const SubmitButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Pressable(
        onPress: isLoading.value ? null : onPressed,
        child: Box(
          style: SubmitButtonStyles.base,
          child: isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText(label),
                    if (icon != null) ...[
                      SizedBox(width: w(8)),
                      Icon(icon, color: Colors.white, size: r(18)),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
