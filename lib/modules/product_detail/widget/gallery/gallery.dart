import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/image/image.variant.dart';
import 'package:mix/mix.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../../core/widgets/image/image.dart';
import '../../controller.dart';
import 'gallery.style.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class ProductImageGallery extends GetView<ProductDetailController> {
  final List<String> images;

  const ProductImageGallery({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    // 单图降级为静态图，避免显示无意义的轮播指示器
    if (images.length == 1) {
      return Box(
        style: GalleryStyle.wrapper,
        child: CustomImage(
          imageUrl: images.first,
          aspectRatio: 1,
          shape: CustomImageShape.square,
        ),
      );
    }

    return ZBox(
      style: GalleryStyle.wrapper,
      children: [
        FlutterCarousel.builder(
          itemCount: images.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
                final imageUrl = images[itemIndex];
                return Box(
                  style: GalleryStyle.imageContainer,
                  child: CustomImage(
                    imageUrl: imageUrl,
                    aspectRatio: 1,
                    shape: CustomImageShape.square,
                  ),
                );
              },
          options: FlutterCarouselOptions(
            height: w(390),
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: false,
            showIndicator: false,
            controller: controller.carouselController,
            onPageChanged: (index, reason) {
              controller.updateImageIndex(index);
            },
          ),
        ),

        Positioned(
          bottom: 16.0,
          left: 0,
          right: 0,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isSelected = controller.currentImgIndex.value == index;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
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
                    padding: EdgeInsets.symmetric(
                      vertical: h(8.0),
                      horizontal: 6.0,
                    ),
                    child: Container(
                      width: isSelected ? 24.0 : 6.0,
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
