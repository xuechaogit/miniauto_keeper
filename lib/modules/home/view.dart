import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/l10n/l10n_util.dart';
import '../../core/services/settings_service.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import '../../core/widgets/product/product.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../core/widgets/tag/tag.dart';
import '../../core/widgets/tag/tag.variant.dart';
import 'controller.dart';
import 'widget/personalization_drawer/personalization_drawer.dart';
import 'widget/notice_banner/notice_banner.dart';
import 'widget/section_header/section_header.dart';
import 'widget/new_arrival/new_arrival.dart';

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
              controller: controller.scrollController,
              slivers: [
                SliverToBoxAdapter(child: _buildCarousel()),
                SliverPadding(
                  padding: EdgeInsets.all(h(8)),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      // 公告
                      SliverToBoxAdapter(child: SizedBox(height: h(24))),
                      SliverToBoxAdapter(
                        child: NoticeBanner(controller: controller),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(24))),

                      //热门车车型
                      SliverToBoxAdapter(child: SizedBox(height: h(8))),
                      SectionHeader(title: '热门车型'),
                      SliverToBoxAdapter(child: SizedBox(height: h(16))),
                      SliverToBoxAdapter(child: hotCarList()),
                      SliverToBoxAdapter(child: SizedBox(height: h(24))),

                      //新品速递 (新版)
                      SectionHeader(
                        title: '新品速递',
                        moreText: '发售日历',
                        onMoreTap: () => Get.toNamed('/calender'),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(12))),
                      SliverToBoxAdapter(
                        child: NewArrival(items: controller.hotProducts),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: h(24))),
                      //新品预告
                      SectionHeader(
                        title: '新品预告',
                        onMoreTap: () => Get.toNamed('/calender'),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: h(8))),
                      SliverToBoxAdapter(child: newCarList()),
                      SliverToBoxAdapter(child: SizedBox(height: h(24))),
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
                  child: Image.network(
                    controller.hotProducts.isNotEmpty
                        ? controller
                              .hotProducts[controller
                                  .currentCarouselIndex
                                  .value]
                              .imageUrl
                        : '',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
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
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            context.l10n.appName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => Scaffold.of(context).openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildCarousel() {
    return Obx(() {
      final items = controller.hotProducts.take(3).toList();
      if (items.isEmpty) return const SizedBox.shrink();

      return FlutterCarousel.builder(
        itemCount: items.length,
        itemBuilder: (context, index, pageViewIndex) {
          final p = items[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(p.imageUrl, fit: BoxFit.cover),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: h(100),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: h(16),
                left: w(16),
                right: w(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.tags.isNotEmpty)
                      CustomTag(label: p.tags.first, size: CustomTagSize.small),
                    SizedBox(height: h(8)),
                    Text(
                      p.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: h(4)),
                    Text(
                      '¥${p.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: sp(20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        options: FlutterCarouselOptions(
          height: w(390),
          autoPlay: true,
          controller: controller.carouselController,
          autoPlayInterval: const Duration(seconds: 3),
          showIndicator: true,
          slideIndicator: CircularSlideIndicator(),
          viewportFraction: 1.0,
          pauseAutoPlayOnTouch: true,
          pauseAutoPlayOnManualNavigate: true,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            controller.currentCarouselIndex.value = index;
          },
        ),
      );
    });
  }

  Widget hotCarList() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HBox(
          children: controller.hotProducts.map((p) {
            return Padding(
              padding: EdgeInsets.only(right: w(8)),
              child: SizedBox(
                width: w(120),
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
                          $text.overflow(TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(height: h(4)),
                      HBox(
                        children: [
                          StyledIcon(
                            Icons.star,
                            style: Style(
                              $icon.color.ref(mxt.color.onSurfaceVariant),
                              $icon.size(r(14)),
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
