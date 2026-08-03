import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart' hide Box;
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/widgets/image/image.dart';
import 'package:miniauto_keeper/models/brand_model.dart';
import 'package:mix/mix.dart';

import 'brand_selector_sheet.style.dart';

class BrandSelectorSheet extends StatefulWidget {
  const BrandSelectorSheet({super.key});

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return SizedBox(
      height: sheetHeight,
      child: Box(
        style: BrandSelectorSheetStyle.sheetContainer,
        child: Column(
          children: [
            Center(child: Box(style: BrandSelectorSheetStyle.dragHandle)),
            Box(
              style: Style($box.margin.bottom(12)),
              child: StyledText('选择品牌', style: BrandSelectorSheetStyle.title),
            ),

            // 搜索框
            Box(
              style: BrandSelectorSheetStyle.searchBar,
              child: HBox(
                style: Style($flex.gap(8), $flex.crossAxisAlignment.center()),
                children: [
                  StyledIcon(
                    Icons.search,
                    style: BrandSelectorSheetStyle.searchIcon,
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

            // 品牌网格（固定高度区域，内部滚动，防止内容变化时抖动）
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
                    crossAxisCount: BrandSelectorSheetStyle.crossAxisCount,
                    mainAxisSpacing: BrandSelectorSheetStyle.mainAxisSpacing,
                    crossAxisSpacing: BrandSelectorSheetStyle.crossAxisSpacing,
                    childAspectRatio: BrandSelectorSheetStyle.childAspectRatio,
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
        style: BrandSelectorSheetStyle.tileContainer,
        children: [
          Box(
            style: BrandSelectorSheetStyle.tileImageBox,
            child: CustomImage(imageUrl: brand.thumb, aspectRatio: 1),
          ),
          StyledText(brand.name, style: BrandSelectorSheetStyle.tileName),
        ],
      ),
    );
  }
}

/// 弹出品牌选择器 bottom sheet，返回用户选中的 BrandModel
Future<BrandModel?> showBrandSelectorSheet() {
  return Get.bottomSheet<BrandModel>(
    const BrandSelectorSheet(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 350),
    exitBottomSheetDuration: const Duration(milliseconds: 250),
  );
}
