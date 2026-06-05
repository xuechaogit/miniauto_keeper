import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/l10n/l10n_util.dart'; // 导入我们之前的扩展
import '../../core/services/settings_service.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/widgets/product/product.dart';
import '../../core/widgets/tag/tag.dart';
import '../../core/widgets/tag/tag.variant.dart';
import 'controller.dart';
import 'widget/personalization_drawer/personalization_drawer.dart';

class buildTitleStyle {
  static Style get titleStyle => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.headline3),
  );

  static Style get moreStyle => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.ref(mxt.textStyle.body),
  );

  static Style get moreIconStyle =>
      Style($icon.color.ref(mxt.color.onSurfaceVariant), $icon.size(14));
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName), // 使用国际化
        centerTitle: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      // 3. 配置右侧抽屉
      endDrawer: PersonalizationDrawer(context),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverMainAxisGroup(
              slivers: [
                //公告
                SliverToBoxAdapter(child: Text('公告')),

                SliverToBoxAdapter(child: SizedBox(height: 24)),

                //热门车车型
                _buildHeader('热门车型'),
                SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(child: hotCarList()),

                SliverToBoxAdapter(child: SizedBox(height: 24)),

                //新品预告
                _buildHeader(
                  '新品预告',
                  onMoreTap: () {
                    Get.toNamed('/calender');
                  },
                ),
                SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(child: newCarList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, {VoidCallback? onMoreTap}) {
    return SliverToBoxAdapter(
      child: HBox(
        style: Style($flex.mainAxisAlignment.spaceBetween()),
        children: [
          StyledText(title, style: buildTitleStyle.titleStyle),

          PressableBox(
            onPress: onMoreTap,
            child: HBox(
              children: [
                StyledText('More', style: buildTitleStyle.moreStyle),
                const SizedBox(width: 4),
                StyledIcon(
                  Icons.arrow_forward_ios,
                  style: buildTitleStyle.moreIconStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget hotCarList() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HBox(
          children: controller.hotProducts.map((p) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 160,
                child: ProductItem(
                  p,
                  details: VBox(
                    children: [
                      StyledText(
                        '${p.title}',
                        style: Style(
                          $text.color.ref(mxt.color.onSurface),
                          $text.style.ref(mxt.textStyle.body),
                          $text.maxLines(1),
                        ),
                      ),
                      SizedBox(height: 4),
                      HBox(
                        children: [
                          StyledIcon(
                            Icons.star,
                            style: Style(
                              $icon.color.ref(mxt.color.onSurfaceVariant),
                              $icon.size(14),
                            ),
                          ),
                          StyledText(
                            '${123} 人收藏',
                            style: Style(
                              $text.color.ref(mxt.color.onSurface),
                              $text.style.ref(mxt.textStyle.caption),
                              $text.maxLines(1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget newCarList() {
    return Obx(
      () => VBox(
        children: controller.hotProducts.map((p) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ProductItem(
              p,
              isListMode: true,
              details: HBox(
                children: [
                  Expanded(
                    child: FlexBox(
                      direction: Axis.vertical,
                      style: Style(
                        $flex.gap(4),
                        $flex.crossAxisAlignment.start(),
                      ),
                      children: [
                        HBox(
                          style: Style($flex.gap(8)),
                          children: [
                            StyledText(
                              '${p.brandName}',
                              style: Style(
                                $text.color.ref(mxt.color.onSurface),
                                $text.style.ref(mxt.textStyle.body),
                                $text.fontWeight.bold(),
                              ),
                            ),
                            CustomTag(label: '新品上新', size: CustomTagSize.small),
                          ],
                        ),
                        StyledText(
                          '${p.title}',
                          style: Style(
                            $text.color.ref(mxt.color.onSurface),
                            $text.style.ref(mxt.textStyle.body),
                            $text.maxLines(2),
                            $text.overflow(TextOverflow.ellipsis),
                          ),
                        ),
                        StyledText(
                          '预计发售：2025年7月',
                          style: Style(
                            $text.color.ref(mxt.color.onSurfaceVariant),
                            $text.style.ref(mxt.textStyle.caption),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 40),

                  Box(
                    style: Style($box.width(80)),
                    child: VBox(
                      style: Style(
                        $flex.mainAxisAlignment.center(),
                        $flex.gap(4),
                      ),
                      children: [
                        StyledText(
                          '距发售还有',
                          style: Style(
                            $text.color.ref(mxt.color.onSurfaceVariant),
                            $text.style.ref(mxt.textStyle.caption),
                          ),
                        ),
                        HBox(
                          style: Style(
                            $flex.mainAxisAlignment.center(),
                            $flex.crossAxisAlignment.baseline(),
                            $flex.textBaseline.alphabetic(), // ← 这个
                            $flex.gap(4),
                          ),
                          children: [
                            StyledText(
                              '${12}',
                              style: Style(
                                $text.color.ref(mxt.color.primary),
                                $text.style.ref(mxt.textStyle.headline1),
                              ),
                            ),
                            StyledText(
                              '天',
                              style: Style(
                                $text.color.ref(mxt.color.onSurfaceVariant),
                                $text.style.ref(mxt.textStyle.caption),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
