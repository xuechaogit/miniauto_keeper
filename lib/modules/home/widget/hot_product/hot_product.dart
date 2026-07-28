import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/core/widgets/image/image.variant.dart';
import 'package:miniauto_keeper/models/product_model.dart';
import 'package:mix/mix.dart';

import 'hot_product.style.dart';

class HotProduct extends StatefulWidget {
  final List<ProductModel> products;
  final VoidCallback? onViewMore;

  const HotProduct({super.key, required this.products, this.onViewMore});

  @override
  State<HotProduct> createState() => _HotProductState();
}

class _HotProductState extends State<HotProduct> {
  late final FlutterCarouselController _carouselController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController = FlutterCarouselController();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;

    return Box(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZBox(
            style: Style($with.aspectRatio(1)),
            children: [
              //背景图
              Positioned.fill(
                child: Box(
                  style: HotProductStyle.bgContainer,
                  child: StyledImage(
                    image: const AssetImage(
                      'assets/images/product_display_bg.jpg',
                    ),
                    style: HotProductStyle.bgImage,
                  ),
                ),
              ),
              Center(
                child: HBox(
                  children: [
                    SizedBox(width: w(8)),
                    _buildArrow(isLeft: true),
                    SizedBox(width: w(8)),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return FlutterCarousel(
                            items: widget.products.map((p) {
                              return CustomImage(
                                imageUrl: p.thumb,
                                aspectRatio: 1.0,
                                shape: CustomImageShape.square,
                              );
                            }).toList(),
                            options: FlutterCarouselOptions(
                              height: constraints.maxWidth,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: true,
                              showIndicator: false,
                              autoPlay: false,
                              controller: _carouselController,
                              onPageChanged: (index, reason) {
                                setState(() => _currentIndex = index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: w(8)),
                    _buildArrow(isLeft: false),
                    SizedBox(width: w(8)),
                  ],
                ),
              ),
            ],
          ),
          Box(
            style: HotProductStyle.infoCard,
            child: VBox(
              style: HotProductStyle.infoArea,
              children: [
                StyledText(
                  widget.products[_currentIndex].title,
                  style: HotProductStyle.title,
                ),
                StyledText(
                  widget.products[_currentIndex].brandName,
                  style: HotProductStyle.brandName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrow({required bool isLeft}) {
    return PressableBox(
      onPress: () {
        if (isLeft) {
          _carouselController.previousPage();
        } else {
          _carouselController.nextPage();
        }
      },
      child: Box(
        style: HotProductStyle.arrowButton,
        child: StyledIcon(
          isLeft ? Icons.chevron_left : Icons.chevron_right,
          style: HotProductStyle.arrowIcon,
        ),
      ),
    );
  }
}
