import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/app_logo/app_logo.dart';
import 'package:mix/mix.dart';
import '../../core/l10n/l10n_util.dart';
import '../../core/services/settings_service.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/widgets/product/product.dart';
import '../../core/widgets/tag/tag.dart';
import '../../core/widgets/tag/tag.variant.dart';
import 'controller.dart';
import 'widget/personalization_drawer/personalization_drawer.dart';
import 'widget/notice_banner/notice_banner.dart';
import 'widget/section_header/section_header.dart';
import 'widget/new_arrival/new_arrival.dart';
import 'widget/brand_section/brand_section.dart';
import 'widget/hot_product/hot_product.dart';
import 'widget/carousel/carousel.dart';
import '../main/controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return Scaffold(
      endDrawer: PersonalizationDrawer(context),
      body: Builder(
        builder: (scaffoldContext) => Stack(
          children: [
            CustomScrollView(
              key: const PageStorageKey('home_scroll'),
              controller: controller.scrollController,
              slivers: [
                //热门车车型
                SliverToBoxAdapter(
                  child: Obx(() {
                    final items = controller.hotProducts.toList();
                    if (items.isEmpty) return const SizedBox.shrink();
                    return HomeCarousel(items: items);
                  }),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: w(12),
                  ),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      // 公告
                      SliverToBoxAdapter(child: SizedBox(height: h(36))),
                      SliverToBoxAdapter(
                        child: NoticeBanner(controller: controller),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(24))),

                      SectionHeader(
                        title: '车模品牌',
                        moreText: '更多',
                        onMoreTap: () =>
                            Get.find<MainController>().changePage(1),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(16))),
                      // 车模品牌
                      SliverToBoxAdapter(
                        child: Obx(
                          () =>
                              BrandSection(brands: controller.brands.toList()),
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(36))),

                      //热销商品
                      SectionHeader(title: '热销商品'),
                      SliverToBoxAdapter(child: SizedBox(height: h(16))),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          final items = controller.hotProducts.take(3).toList();
                          if (items.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return HotProduct(products: items);
                        }),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(36))),

                      //新品速递 (新版)
                      SectionHeader(
                        title: '新品速递',
                        moreText: '发售日历',
                        onMoreTap: () => Get.toNamed('/calender'),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(16))),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          final items = controller.hotProducts.toList();
                          if (items.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return NewArrival(items: items);
                        }),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: h(36))),
                      //新品预告
                      // SectionHeader(
                      //   title: '新品预告',
                      //   onMoreTap: () => Get.toNamed('/calender'),
                      // ),
                      // SliverToBoxAdapter(child: newCarList()),
                      // SliverToBoxAdapter(child: SizedBox(height: h(24))),
                    ],
                  ),
                ),
              ],
            ),
            _buildFloatingAppBar(scaffoldContext),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Obx(() {
        if (controller.isScrolled.value) {
          return Container(
            height: kToolbarHeight + topPadding,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: context.color(mxt.color.surface)),
                ),
                Positioned(
                  top: topPadding,
                  left: 0,
                  right: 0,
                  height: kToolbarHeight,
                  child: _buildTitleRow(context),
                ),
              ],
            ),
          );
        } else {
          return Container(
            height: kToolbarHeight + topPadding,
            padding: EdgeInsets.only(top: topPadding),
            child: _buildTitleRow(context),
          );
        }
      }),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: w(12)),
        AppLogo(height: 32),
        const Spacer(),
        IconButton(
          icon: StyledIcon(
            Icons.settings,
            style: Style($icon.color.ref(mxt.color.onSurface)),
          ),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ],
    );
  }

  Widget newCarList() {
    return Obx(
      () => VBox(
        children: controller.hotProducts.map((p) {
          return Padding(
            padding: EdgeInsets.only(bottom: h(8)),
            child: ProductItem(
              p,
              isListMode: true,
              details: VBox(
                style: Style($box.height(w(100))),
                children: [
                  HBox(
                    style: Style($flex.gap(w(8))),
                    children: [
                      StyledText(
                        '${p.brandName}',
                        style: Style(
                          $text.color.ref(mxt.color.onSurface),
                          $text.style.ref(mxt.textStyle.headline3),
                          $text.fontWeight.bold(),
                        ),
                      ),
                      CustomTag(label: '新品上新', size: CustomTagSize.small),
                    ],
                  ),
                  HBox(style: Style($box.height(w(8)))),
                  Expanded(
                    flex: 1,
                    child: HBox(
                      style: Style($flex.gap.ref(mxt.space.medium)),
                      children: [
                        Expanded(
                          child: FlexBox(
                            direction: Axis.vertical,
                            style: Style(
                              $flex.gap(h(4)),
                              $flex.mainAxisAlignment.spaceBetween(),
                              $flex.crossAxisAlignment.start(),
                            ),
                            children: [
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

                        Box(
                          style: Style($box.width(w(60))),
                          child: VBox(
                            style: Style(
                              $flex.mainAxisAlignment.center(),
                              $flex.gap(h(4)),
                            ),
                            children: [
                              StyledText(
                                '距发售',
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
                                  $flex.gap(h(4)),
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
                                      $text.color.ref(
                                        mxt.color.onSurfaceVariant,
                                      ),
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
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
