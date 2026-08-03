import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:mix/mix.dart';

import 'package:miniauto_keeper/core/theme/app_theme.dart';
import '../../controller.dart';
import '../brand_app_bar/brand_app_bar.dart';
import 'brand_info_header.style.dart';

class BrandInfoHeaderWidget extends GetView<BrandDetailController> {
  const BrandInfoHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = controller.brand;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/racing_flags.jpg'),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Container(
        color: context.color(mxt.color.surface).withOpacity(0.7),
        child: VBox(
          children: [
            Box(
              style: Style(
                $box.padding.horizontal(w(12)),
                $box.padding.vertical(w(6)),
              ),
              child: BrandSearchBar(),
            ),

            Box(
              style: BrandInfoHeaderStyle.outerPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ── Logo ──
                      Box(
                        style: BrandInfoHeaderStyle.logoBox,
                        child: CustomImage(
                          imageUrl: brand.name,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: BrandInfoHeaderStyle.logoSpacing),

                      // ── 左侧：品牌名 + 切换品牌 ──
                      VBox(
                        style: Style(
                          $box.height(64),
                          $flex.mainAxisAlignment.start(),
                          $flex.crossAxisAlignment.start(),
                          $with.flexible(flex: 1, fit: FlexFit.tight),
                        ),
                        children: [
                          StyledText(
                            brand.name.toUpperCase(),
                            style: BrandInfoHeaderStyle.brandName,
                          ),
                          const SizedBox(height: 4),
                          PressableBox(
                            onPress: controller.switchBrand,
                            child: Box(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StyledIcon(
                                    Icons.swap_horiz,
                                    style: BrandInfoHeaderStyle.switchBrandIcon,
                                  ),
                                  Box(style: Style($box.width(w(4)))),
                                  StyledText(
                                    '切换品牌',
                                    style: BrandInfoHeaderStyle.switchBrandText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── 右侧：收录商品 + 缺失上报 ──
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StyledText(
                            '收录商品：10 款',
                            style: BrandInfoHeaderStyle.countText,
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: controller.reportMissing,
                            child: Box(
                              style: BrandInfoHeaderStyle.pillContainer,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StyledIcon(
                                    Icons.report_outlined,
                                    style: BrandInfoHeaderStyle.reportIcon,
                                  ),
                                  Box(style: Style($box.width(w(4)))),
                                  StyledText(
                                    '缺失上报',
                                    style: BrandInfoHeaderStyle.reportText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ── 描述区 ──
                  Box(
                    style: BrandInfoHeaderStyle.descTopGap,
                    child: _buildCollapsibleDescription(),
                  ),
                ],
              ),
            ),

            Box(
              style: Style(
                $box.height(w(16)),
                $box.borderRadius.topLeft(r(16)),
                $box.borderRadius.topRight(r(16)),
                $box.color.ref(mxt.color.background),
                $box.shadow(
                  color: Colors.black.withOpacity(0.06), // 阴影颜色与透明度
                  offset: const Offset(0, -4), // y 轴为负数，表示向上偏移
                  blurRadius: 8, // 模糊半径
                  spreadRadius: 0, // 扩散半径
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleDescription() {
    return Obx(() {
      const desc =
          '该品牌以精湛的工艺和卓越的设计闻名于世，自创立以来一直致力于为收藏家提供高精度的汽车模型。'
          '每一款产品都经过严格的品质把控，从模具开发到涂装工艺，力求完美还原真车的每一个细节，'
          '是车模收藏领域不可忽视的重要力量。';

      final expanded = controller.isDescriptionExpanded.value;

      if (expanded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText(desc, style: BrandInfoHeaderStyle.descriptionText),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: controller.toggleDescription,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StyledText('收起', style: BrandInfoHeaderStyle.toggleText),
                      StyledIcon(
                        Icons.keyboard_arrow_up,
                        style: BrandInfoHeaderStyle.toggleIcon,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StyledText(
              desc,
              style: BrandInfoHeaderStyle.collapsedDescText,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: controller.toggleDescription,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledText('展开', style: BrandInfoHeaderStyle.toggleText),
                StyledIcon(
                  Icons.keyboard_arrow_down,
                  style: BrandInfoHeaderStyle.toggleIcon,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
