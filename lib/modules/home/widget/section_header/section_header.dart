import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import 'section_header.style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMoreTap;
  final String moreText;

  const SectionHeader({
    super.key,
    required this.title,
    this.onMoreTap,
    this.moreText = 'More',
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HBox(
        style: SectionHeaderStyle.container,
        children: [
          StyledText(title, style: SectionHeaderStyle.title),
          if (onMoreTap != null)
            PressableBox(
              onPress: onMoreTap,
              child: HBox(
                style: SectionHeaderStyle.moreRow,
                children: [
                  StyledText(moreText, style: SectionHeaderStyle.moreText),
                  StyledIcon(
                    Icons.arrow_forward_ios,
                    style: SectionHeaderStyle.moreIcon,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
