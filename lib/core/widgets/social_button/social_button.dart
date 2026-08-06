import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'social_button.style.dart';
import 'social_button.variant.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.type = SocialButtonTypeVariant.primary,
    this.fill = SocialButtonFillVariant.fill,
    this.size = SocialButtonSizeVariant.defaults,
    this.shape = SocialButtonShapeVariant.rounded,
    this.loading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final SocialButtonTypeVariant type;
  final SocialButtonFillVariant fill;
  final SocialButtonSizeVariant size;
  final SocialButtonShapeVariant shape;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final style = SocialButtonStyle(
      type: type,
      fill: fill,
      size: size,
      shape: shape,
    );

    return Material(
      color: style.containerColor(context),
      borderRadius: style.borderRadius(),
      child: InkWell(
        onTap: loading ? null : onTap,
        hoverColor: style.hoverColor(context),
        borderRadius: style.borderRadius(),
        child: Box(
          style: style.main,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                _Loader(color: style.loaderColor(context), size: style.loaderSize)
              else
                StyledIcon(icon, style: style.iconStyle),
              const SizedBox(width: 8),
              StyledText(label, style: style.labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
