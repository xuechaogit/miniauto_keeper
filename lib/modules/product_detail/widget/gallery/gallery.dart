import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../../core/widgets/image/image.dart';
import '../../controller.dart';
import 'gallery.style.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class ProductImageGallery extends GetView<ProductDetailController> {
  final dynamic data; // 承接你的商品详情对象数据

  const ProductImageGallery({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZBox(
      style: GalleryStyle.wrapper,
      children: [
        // 图层一：宽幅全屏铺满的多图画廊
        FlutterCarousel.builder(
          itemCount: data.images.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
                final imageUrl = data.images[itemIndex];
                return Box(
                  style: GalleryStyle.imageContainer,
                  child: CustomImage(imageUrl: imageUrl, aspectRatio: 1),
                );
              },
          options: FlutterCarouselOptions(
            height: 300.0,
            viewportFraction: 1.0, // 单图 100% 占满屏幕宽
            enlargeCenterPage: false, // 禁用单图下的缩放闪烁
            autoPlay: false,
            showIndicator: false, // 关闭原生自带指示器
            controller: controller.carouselController, // 绑定控制状态
            onPageChanged: (index, reason) {
              controller.updateImageIndex(index);
            },
          ),
        ),

        // 图层二：绝对定位到大图内侧底部的 LED 刻度仪表盘联动指示器
        Positioned(
          bottom: 16.0,
          left: 0,
          right: 0,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(data.images.length, (index) {
                final isSelected = controller.currentImgIndex.value == index;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque, // 提升极细刻度条的手势命中率
                  onTap: () {
                    controller.carouselController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    // 隐形防呆扩展热区，防止手指粗误触
                    padding: EdgeInsets.symmetric(vertical: h(8.0),
                      horizontal: 6.0,
                    ),
                    child: Container(
                      width: isSelected ? 24.0 : 6.0, // 动态拉伸质感
                      height: 3.5,
                      decoration: GalleryStyle.ledIndicator(
                        isSelected: isSelected,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ],
    );
  }
}
