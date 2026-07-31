import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';
import '../../../../models/product_model.dart';

import '../../image/image.dart';
import '../product.style.dart';
import '../product.variant.dart';

class ProductGridLayout extends StatefulWidget {
  final ProductModel product;
  final Widget? details;

  const ProductGridLayout(this.product, {super.key, this.details});

  @override
  State<ProductGridLayout> createState() => _ProductGridLayoutState();
}

class _ProductGridLayoutState extends State<ProductGridLayout> {
  bool _isFav = false;

  void _toggleFav() {
    setState(() => _isFav = !_isFav);
  }

  void _onAddToGarage() {
    Get.snackbar(
      'SYSTEM',
      '入库单生成中...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFE54335),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 应用 gridMode 变体
    final style = ProductStyle.container.applyVariant(ProductMode.gridMode);

    return Box(
      style: style,
      child: VBox(
        style: ProductStyle.gridGap,
        children: [
          // 图片
          Box(
            style: ProductStyle.image.applyVariant(ProductMode.gridMode),
            child: CustomImage(imageUrl: widget.product.thumb, aspectRatio: 1),
          ),

          // title + action bar
          widget.details ??
              VBox(
                style: Style($flex.gap(6)),
                children: [
                  Box(
                    style: Style($box.height(sp(40))),
                    child: StyledText(
                      widget.product.title,
                      style: ProductStyle.title.applyVariant(
                        ProductMode.gridMode,
                      ),
                    ),
                  ),
                  HBox(
                    style: ProductStyle.gridActionBar,
                    children: [
                      // 收藏
                      PressableBox(
                        onPress: _toggleFav,
                        child: StyledIcon(
                          _isFav ? Icons.star_sharp : Icons.star_border_sharp,
                          style: Style(
                            $icon.size(sp(24)),
                            $icon.color(
                              _isFav
                                  ? const Color(0xFFE54335)
                                  : const Color(0xFF888888),
                            ),
                          ),
                        ),
                      ),

                      // 加入车库
                      Expanded(
                        child: PressableBox(
                          onPress: _onAddToGarage,
                          child: HBox(
                            style: ProductStyle.gridAddGarageBtn,
                            children: [
                              StyledText(
                                '加入车库',
                                style: ProductStyle.gridAddGarageBtnText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
