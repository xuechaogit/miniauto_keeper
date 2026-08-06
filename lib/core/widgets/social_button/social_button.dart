import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'social_button.style.dart';
import 'social_button.variant.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.onTap,
    this.type = SocialButtonTypeVariant.primary,
    this.fill = SocialButtonFillVariant.fill,
    this.size = SocialButtonSizeVariant.defaults,
    this.shape = SocialButtonShapeVariant.rounded,
    this.loading = false,
    this.child,
    this.prefixIcon,
    this.label,
    this.suffixIcon,
  }) : assert(child != null || label != null,
            'Provide either child or label');

  final VoidCallback onTap;
  final SocialButtonTypeVariant type;
  final SocialButtonFillVariant fill;
  final SocialButtonSizeVariant size;
  final SocialButtonShapeVariant shape;
  final bool loading;
  final Widget? child;
  final IconData? prefixIcon;
  final String? label;
  final IconData? suffixIcon;

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
          child: loading
              ? VBox(
                  style: Style(
                    $flex.mainAxisAlignment.center(),
                    $flex.mainAxisSize.min(),
                  ),
                  children: [
                    _Loader(
                      color: style.loaderColor(context),
                      size: style.loaderSize,
                    ),
                  ],
                )
              : _content(style),
        ),
      ),
    );
  }

  Widget _content(SocialButtonStyle style) {
    if (child != null) {
      return child!;
    }

    final children = <Widget>[];
    if (prefixIcon != null) {
      children.add(StyledIcon(prefixIcon!, style: style.iconStyle));
      children.add(const SizedBox(width: 8));
    }
    children.add(StyledText(label!, style: style.labelStyle));
    if (suffixIcon != null) {
      children.add(const SizedBox(width: 8));
      children.add(StyledIcon(suffixIcon!, style: style.iconStyle));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
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
      child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
    );
  }
}
