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
                TextField(
                  // 1. 同步文字样式
                  style: context.textStyle(mxt.textStyle.body),

                  decoration: InputDecoration(
                    // A. 默认状态的边框（未选中时）
                    hintText: 'Search Your collection...',
                    // 💡 关键：必须设为 true
                    filled: true,
                    // 使用 context 扩展引用 Token
                    fillColor: context.color(mxt.color.surfaceVariant),
                    // 3. 使用 Token 圆角
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        context.radius(mxt.radius.large),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    // 4. 使用 Token 间距
                    contentPadding: EdgeInsets.all(
                      context.space(mxt.space.large),
                    ),

                    prefixIcon: Icon(
                      Icons.search,
                      color: context.color(mxt.color.primary),
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
