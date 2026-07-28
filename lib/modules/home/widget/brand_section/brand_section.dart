import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/core/widgets/image/image.variant.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:miniauto_keeper/modules/main/controller.dart';
import 'package:mix/mix.dart';

import 'brand_section.style.dart';

/// 车模品牌展示区域 — Wrap 居中 + 三档大小
class BrandSection extends StatefulWidget {
  final List<BrandModel> brands;
  final VoidCallback? onMoreTap;

  const BrandSection({super.key, required this.brands, this.onMoreTap});

  @override
  State<BrandSection> createState() => _BrandSectionState();
}

class _BrandSectionState extends State<BrandSection> {
  int? _selectedIndex;

  /// 分档：第1、4个为大号，其余中号
  int _tier(int index) => (index == 0 || index == 3) ? 2 : 1;

  @override
  Widget build(BuildContext context) {
    if (widget.brands.isEmpty) return const SizedBox.shrink();

    return Box(
      style: BrandSectionStyle.wrapContainer,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: w(8),
        runSpacing: h(16),
        children: List.generate(widget.brands.length, (i) {
          return _brandCard(widget.brands[i], i);
        }),
      ),
    );
  }

  Widget _brandCard(BrandModel brand, int index) {
    final isSelected = _selectedIndex == index;
    final t = _tier(index);
    final hasIcon = brand.thumb.isNotEmpty;

    final pillStyle = switch (t) {
      2 => BrandSectionStyle.pillLarge,
      1 => BrandSectionStyle.pillMedium,
      _ => BrandSectionStyle.pillSmall,
    };
    final nameStyle = switch (t) {
      2 => BrandSectionStyle.nameLarge,
      1 => BrandSectionStyle.nameMedium,
      _ => BrandSectionStyle.nameSmall,
    };

    final iconSize = switch (t) {
      2 => w(26),
      1 => w(26),
      _ => 0.0,
    };

    return PressableBox(
      onPress: () {
        Get.find<MainController>().changePage(1);
      },
      child: HBox(
        style: Style.combine([
          pillStyle,
          if (isSelected) BrandSectionStyle.cardSelected,
        ]),
        children: [
          if (hasIcon && iconSize > 0)
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: CustomImage(
                imageUrl: brand.thumb,
                shape: CustomImageShape.circle,
              ),
            ),
          StyledText(
            brand.name,
            style: Style.combine([
              nameStyle,
              if (isSelected) BrandSectionStyle.nameSelected,
            ]),
          ),
        ],
      ),
    );
  }
}
