import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/core/widgets/image/image.variant.dart';
import 'package:miniauto_keeper/core/widgets/tag/tag.dart';
import 'package:miniauto_keeper/core/widgets/tag/tag.variant.dart';
import 'package:miniauto_keeper/models/car_model.dart';

import 'package:mix/mix.dart';

import '../../controller.dart';
import 'carousel.style.dart';

class HomeCarousel extends GetView<HomeController> {
  final List<CarModel> items;

  const HomeCarousel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Box(
      style: CarouselStyle.container,
      child: FlutterCarousel.builder(
        itemCount: items.length,
        itemBuilder: (context, index, pageViewIndex) {
          final p = items[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomImage(
                imageUrl: p.coverImage,
                aspectRatio: 1,
                shape: CustomImageShape.square,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: h(80),
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
                bottom: h(12),
                left: w(12),
                right: w(12),
                child: HBox(
                  style: Style($flex.crossAxisAlignment.start()),
                  children: [
                    VBox(
                      style: Style(
                        $flex.crossAxisAlignment.start(),
                        $with.flexible(flex: 1, fit: FlexFit.tight),
                      ),
                      children: [
                        Box(
                          // style: CarouselStyle.titleWrapper,
                          child: StyledText(p.name, style: CarouselStyle.title),
                        ),
                        SizedBox(height: w(8)),
                        _buildIndicator(pageViewIndex, items.length),
                      ],
                    ),
                    SizedBox(height: w(32)),
                    VBox(
                      children: [
                        StyledText('PRICE', style: CarouselStyle.priceLabel),
                        SizedBox(height: w(8)),
                        StyledText(
                          '\$ ${p.marketPrice}',
                          style: CarouselStyle.price,
                        ),
                      ],
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
          showIndicator: false,
          viewportFraction: 1.0,
          pauseAutoPlayOnTouch: true,
          pauseAutoPlayOnManualNavigate: true,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            controller.currentCarouselIndex.value = index;
          },
        ),
      ),
    );
  }

  Widget _buildIndicator(int current, int total) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final active = i == current;
        return Box(
          style: active
              ? CarouselStyle.indicatorActive
              : CarouselStyle.indicatorInactive,
        );
      }),
    );
  }
}
