import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart' hide Box;
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:mix/mix.dart';

import 'brand_selector.style.dart';

class BrandSelectorSheet extends StatefulWidget {
  final String title;
  final List<BrandModel>? brands;

  const BrandSelectorSheet({
    super.key,
    this.title = '选择品牌',
    this.brands,
  });

  @override
  State<BrandSelectorSheet> createState() => _BrandSelectorSheetState();
}

class _BrandSelectorSheetState extends State<BrandSelectorSheet> {
  final _searchCtrl = TextEditingController();
  final _brands = <BrandModel>[];
  final _filteredBrands = <BrandModel>[].obs;

  @override
  void initState() {
    super.initState();
    _loadBrands();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _loadBrands() {
    if (widget.brands != null) {
      _brands.addAll(widget.brands!);
      _filteredBrands.value = widget.brands!;
      return;
    }

    try {
      final box = Hive.box('cache');
      final cached = box.get('brands');
      if (cached != null && cached is List<BrandModel>) {
        _brands.addAll(cached);
        _filteredBrands.value = cached;
      }
    } catch (_) {}
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase();
    if (query.isEmpty) {
      _filteredBrands.value = _brands;
    } else {
      _filteredBrands.value = _brands
          .where((b) => b.name.toLowerCase().contains(query))
          .toList();
    }
  }

  void _onBrandTap(BrandModel brand) => Get.back(result: brand);

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return SizedBox(
      height: sheetHeight,
      child: Box(
        style: BrandSelectorStyle.sheetContainer,
        child: Column(
          children: [
            Center(child: Box(style: BrandSelectorStyle.dragHandle)),
            Box(
              style: Style($box.margin.bottom(12)),
              child: StyledText(widget.title, style: BrandSelectorStyle.title),
            ),

            // 搜索框
            Box(
              style: BrandSelectorStyle.searchBar,
              child: HBox(
                style: Style($flex.gap(8), $flex.crossAxisAlignment.center()),
                children: [
                  StyledIcon(
                    Icons.search,
                    style: BrandSelectorStyle.searchIcon,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: context
                          .textStyle(mxt.textStyle.body)
                          .copyWith(color: context.color(mxt.color.onSurface)),
                      decoration: const InputDecoration.collapsed(
                        hintText: '搜索品牌名称',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (_filteredBrands.isEmpty) {
                  return Center(
                    child: StyledText(
                      _searchCtrl.text.isNotEmpty ? '未找到匹配品牌' : '暂无品牌数据',
                      style: Style(
                        $text.color.ref(mxt.color.onSurfaceVariant),
                        $text.style.ref(mxt.textStyle.body),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: BrandSelectorStyle.crossAxisCount,
                    mainAxisSpacing: BrandSelectorStyle.mainAxisSpacing,
                    crossAxisSpacing: BrandSelectorStyle.crossAxisSpacing,
                    childAspectRatio: BrandSelectorStyle.childAspectRatio,
                  ),
                  itemCount: _filteredBrands.length,
                  itemBuilder: (_, i) =>
                      _BrandTile(_filteredBrands[i], onTap: _onBrandTap),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  final BrandModel brand;
  final void Function(BrandModel) onTap;

  const _BrandTile(this.brand, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(brand),
      child: VBox(
        style: BrandSelectorStyle.tileContainer,
        children: [
          Box(
            style: BrandSelectorStyle.tileImageBox,
            child: CustomImage(imageUrl: brand.thumb, aspectRatio: 1),
          ),
          StyledText(brand.name, style: BrandSelectorStyle.tileName),
        ],
      ),
    );
  }
}

/// 弹出品牌选择器 bottom sheet，返回用户选中的 BrandModel
Future<BrandModel?> showBrandSelectorSheet({
  List<BrandModel>? brands,
  String title = '选择品牌',
}) {
  return Get.bottomSheet<BrandModel>(
    BrandSelectorSheet(brands: brands, title: title),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 350),
    exitBottomSheetDuration: const Duration(milliseconds: 250),
  );
}
