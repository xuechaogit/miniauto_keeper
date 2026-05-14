import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/router/app_routes.dart';
import '../../core/services/settings_service.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/widgets/tag/tag.dart';

import '../../core/widgets/tag/tag.variant.dart';
import 'controller.dart';
// 导入MIX
import 'package:mix/mix.dart';
import '../../core/theme/app_mix_themes.dart';
import 'widgets/brand_card.dart';

class BrandView extends GetView<BrandsController> {
  const BrandView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: StyledText('PRECISION HUB', style: AppMixStyles.titleStyle),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // 为底部卡片留出空间
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 搜索框
                SizedBox(
                  // 显式约束高度，确保和 FilterChips 在视觉上分量相当
                  height: 40,
                  child: TextField(
                    // 1. 同步文字样式
                    style: context.textStyle(mxt.textStyle.body),
                    onChanged: (value) => null,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      filled: true,
                      fillColor: context.color(mxt.color.surfaceVariant),
                      prefixIcon: Icon(
                        Icons.search,
                        color: context.color(mxt.color.primary),
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          context.radius(mxt.radius.large),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      // 关键：减少垂直 Padding，因为外部已经有 SizedBox 限制高度了
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 标题行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyledText('Brands', style: AppMixStyles.titleStyle),
                    CustomTag(
                      label: 'PREMIUM GREY',
                      type: CustomTagType.primary,
                      size: CustomTagSize.medium,
                      shape: CustomTagShape.rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. 使用 Obx 响应数据变化 (品牌列表)
                Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.brands.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final brand = controller.brands[index];
                      return BrandCard(
                        brand: brand,
                        onTap: () => Get.toNamed(
                          AppRoutes.brandDetail,
                          arguments: brand,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
