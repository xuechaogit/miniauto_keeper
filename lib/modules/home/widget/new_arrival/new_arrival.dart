import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/models/product_model.dart';
import 'package:mix/mix.dart';

import '../../../../core/utils/screen_adapter.dart';
import '../../../../models/home_stats.dart';
import 'new_arrival.style.dart';

/// 新品上新（新版）
/// 顶部为图片轮播（不自动播放，触屏滑动后下方详情卡片有右到左的切换动画），
/// 下方展示当前选中卡片的品牌、标题、发货时间与开售提醒按钮。
class NewArrival extends StatefulWidget {
  final List<ProductModel> items;

  const NewArrival({super.key, required this.items});

  @override
  State<NewArrival> createState() => _NewArrivalState();
}

class _NewArrivalState extends State<NewArrival> {
  final FlutterCarouselController _carouselController =
      FlutterCarouselController();
  final RxInt _currentIndex = 0.obs;

  @override
  void didUpdateWidget(covariant NewArrival oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当外部传入的 items 缩容时，_currentIndex 可能指向越界索引，
    // 需自动 clamp 到有效范围，否则 Obx 中 items[index] 会抛 RangeError
    if (widget.items.length < oldWidget.items.length &&
        _currentIndex.value >= widget.items.length &&
        widget.items.isNotEmpty) {
      _currentIndex.value = widget.items.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _buildCarousel(items),
        SizedBox(height: h(12)),
        _buildDetailPanel(items),
      ],
    );
  }

  // 顶部图片轮播
  Widget _buildCarousel(List<ProductModel> items) {
    return SizedBox(
      height: w(280),
      child: FlutterCarousel.builder(
        itemCount: items.length,
        itemBuilder: (context, index, _) {
          final p = items[index];
          return Padding(
            padding: EdgeInsets.only(right: w(8)),
            child: Box(
              style: NewArrivalStyle.carouselImage,
              child: CustomImage(imageUrl: p.thumb, aspectRatio: 1),
            ),
          );
        },
        options: FlutterCarouselOptions(
          height: w(390) * 0.75 - w(16), // 减去 padding
          autoPlay: false,
          controller: _carouselController,
          viewportFraction: 0.75,
          padEnds: false, // 防止左右滑动时出现空白
          showIndicator: false,
          enableInfiniteScroll: items.length > 1,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            _currentIndex.value = index;
          },
        ),
      ),
    );
  }

  // 下方详情面板：跟随轮播左右切换
  Widget _buildDetailPanel(List<ProductModel> items) {
    return Obx(() {
      final index = _currentIndex.value;
      if (index >= items.length) {
        if (items.isNotEmpty) {
          _currentIndex.value = items.length - 1;
        }
        return const SizedBox.shrink();
      }
      final p = items[index];
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          // 右到左的滑动效果：进入时从右侧滑入，离开时滑向左侧
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.35, 0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: _DetailCard(key: ValueKey('detail_$index'), product: p),
      );
    });
  }
}

class _DetailCard extends StatelessWidget {
  final ProductModel product;
  const _DetailCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: NewArrivalStyle.detailCard,
      child: HBox(
        style: Style($flex.gap(w(12)), $flex.crossAxisAlignment.center()),
        children: [
          // 左侧：品牌 / 标题 / 发售时间
          Expanded(
            child: VBox(
              style: NewArrivalStyle.infoColumn,
              children: [
                StyledText(product.brandName, style: NewArrivalStyle.brandText),
                StyledText(product.title, style: NewArrivalStyle.titleText),
                StyledText(
                  '发售时间：${(product.releaseDate?.isEmpty ?? true) ? '敬请期待' : product.releaseDate!}',
                  style: NewArrivalStyle.deliveryTimeText,
                ),
              ],
            ),
          ),
          // 右侧：开售提醒按钮
          PressableBox(
            onPress: () {
              Get.snackbar(
                '已设置提醒',
                '开售前将通知你',
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(w(16)),
              );
            },
            child: Box(
              style: NewArrivalStyle.reminderButton,
              child: StyledText('开售提醒', style: NewArrivalStyle.reminderText),
            ),
          ),
        ],
      ),
    );
  }
}
