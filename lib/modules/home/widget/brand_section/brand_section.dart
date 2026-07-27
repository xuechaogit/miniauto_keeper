import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:mix/mix.dart';

import 'brand_section.style.dart';

/// 车模品牌展示区域 — 磁吸标签云
/// 品牌以不规则胶囊散布，大/中/小三档尺寸，深色基底 + 霓虹边框。
class BrandSection extends StatelessWidget {
  final List<BrandModel> brands;
  final VoidCallback? onMoreTap;

  const BrandSection({super.key, required this.brands, this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) return const SizedBox.shrink();
    return _buildTagCloud();
  }

  Widget _buildTagCloud() {
    final items = brands.take(12).toList();
    // 随机打乱，增强不规则感
    items.shuffle(Random(42));

    return Box(
      style: BrandSectionStyle.wrapContainer,
      child: Wrap(
        spacing: w(8),
        runSpacing: h(8),
        children: List.generate(items.length, (i) => _pill(items[i], i)),
      ),
    );
  }

  Widget _pill(BrandModel brand, int index) {
    final tier = _tier(index, brands.length);
    return PressableBox(
      onPress: () => Get.toNamed('/brands'),
      child: HBox(
        style: tier.style,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(w(4)),
            child: CustomImage(imageUrl: brand.thumb),
          ),
          StyledText(brand.name, style: tier.textStyle),
        ],
      ),
    );
  }

  _PillTier _tier(int index, int total) {
    if (index < 3) {
      return _PillTier(
        BrandSectionStyle.pillLarge,
        BrandSectionStyle.pillNameLarge,
      );
    } else if (index < 6) {
      return _PillTier(
        BrandSectionStyle.pillMedium,
        BrandSectionStyle.pillNameMedium,
      );
    } else {
      return _PillTier(
        BrandSectionStyle.pillSmall,
        BrandSectionStyle.pillNameSmall,
      );
    }
  }
}

class _PillTier {
  final Style style;
  final Style textStyle;
  const _PillTier(this.style, this.textStyle);
}
