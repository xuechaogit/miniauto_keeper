import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'tag.style.dart';
import 'tag.variant.dart';

typedef TagChildBuilder =
    Widget Function(BuildContext context, CustomTagStyle style);

class CustomTag extends StatelessWidget {
  CustomTag({
    super.key,
    required this.label,
    this.type = CustomTagType.primary,
    this.size = CustomTagSize.medium,
    this.shape = CustomTagShape.rounded,
  }) : builder = null;

  CustomTag.builder({
    super.key,
    required this.builder, // 必填
    this.type = CustomTagType.primary,
    this.size = CustomTagSize.medium,
    this.shape = CustomTagShape.rounded,
  }) : label = null;

  final String? label;
  CustomTagType type = CustomTagType.primary;
  CustomTagSize size = CustomTagSize.medium;
  CustomTagShape shape = CustomTagShape.rounded;
  final TagChildBuilder? builder; // 新增 builder 回调

  @override
  Widget build(BuildContext context) {
    // 实例化你的样式类
    final tagStyle = CustomTagStyle(type: type, size: size, shape: shape);

    return Box(
      style: tagStyle.container(),
      // 如果有 builder 用 builder，否则回退到默认的 StyledText
      child: builder != null
          ? builder!(context, tagStyle)
          : StyledText(label ?? '', style: tagStyle.label()),
    );
  }
}
