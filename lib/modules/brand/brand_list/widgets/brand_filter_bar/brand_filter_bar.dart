import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:mix/mix.dart';

import '../../controller.dart';
import 'brand_filter_bar.style.dart';

class BrandFilterBarDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding; // 状态栏高度

  BrandFilterBarDelegate({required this.topPadding});

  // 筛选栏本身的真实高度（比如 44）
  double get _filterBarHeight => 48.0;

  // 1. 最小高度：吸顶时的总占用高度 = 悬浮 AppBar 高度 + 筛选栏本身高度
  @override
  double get minExtent => _filterBarHeight + kToolbarHeight + topPadding;

  // 2. 最大高度：未吸顶展开时的总占用高度
  @override
  double get maxExtent => _filterBarHeight + kToolbarHeight + topPadding;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      // 给筛选栏顶部留出【悬浮 AppBar 的空间】，确保内容只在 AppBar 下方绘制
      padding: EdgeInsets.only(top: kToolbarHeight + topPadding),
      color: context.color(mxt.color.background), // 背景色，避免向下滚动时透出底下的内容
      child: const BrandFilterBar(), // 你的真实筛选栏 Widget
    );
  }

  @override
  bool shouldRebuild(covariant BrandFilterBarDelegate oldDelegate) {
    // 确保比较逻辑准确，不要写成盲目返回 true
    return oldDelegate.topPadding != topPadding;
  }
}

class BrandFilterBar extends GetView<BrandDetailController> {
  const BrandFilterBar({super.key});

  static const _sortOptions = ['综合', '销量', '价格升', '价格降', '新品'];
  static const _categoryOptions = [
    '全部',
    'JDM / Custom',
    'Global Edition',
    'Motorsport',
    'Premium Diecast',
    'Classic Euro',
    'High-End Resin',
  ];
  static const _brandOptions = [
    '全部',
    'Porsche',
    'Ferrari',
    'Lamborghini',
    'BMW',
    'Audi',
    'Mercedes',
    'McLaren',
    'Nissan',
    'Toyota',
    'Honda',
    'Bugatti',
    'Aston Martin',
    'Ford',
    'Chevrolet',
    'Koenigsegg',
    'Lexus',
    'Mazda',
    'Subaru',
    'Alpine',
    'Mitsubishi',
  ];
  static const _specOptions = ['全部', '1:18', '1:43', '1:64'];

  void _onFilterChanged(String uiKey, String value) {
    if (_currentFilterValue(uiKey) == value) return;

    switch (uiKey) {
      case 'sort':
        const sortMap = {
          '综合': '默认',
          '销量': '销量',
          '价格升': '价格从低到高',
          '价格降': '价格从高到低',
          '新品': '新品',
        };
        final mapped = sortMap[value] ?? value;
        controller.selectedSort.value = mapped;
        controller.applyFilter('sort', mapped);
      case 'category':
        controller.selectedSeries.value = value;
        controller.applyFilter('series', value);
      case 'brand':
        controller.selectedYear.value = value;
        controller.applyFilter('year', value);
      case 'spec':
        controller.selectedScale.value = value;
        controller.applyFilter('scale', value);
    }
  }

  String _currentFilterValue(String uiKey) {
    switch (uiKey) {
      case 'sort':
        const reverseSortMap = {'默认': '综合', '价格从低到高': '价格升', '价格从高到低': '价格降'};
        return reverseSortMap[controller.selectedSort.value] ??
            controller.selectedSort.value;
      case 'category':
        return controller.selectedSeries.value;
      case 'brand':
        return controller.selectedYear.value;
      case 'spec':
        return controller.selectedScale.value;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color(mxt.color.background),
      child: Box(
        style: BrandFilterBarStyle.barPadding,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildChip(
                context,
                label: '排序',
                uiKey: 'sort',
                options: _sortOptions,
              ),
              SizedBox(width: BrandFilterBarStyle.chipGap),
              _buildChip(
                context,
                label: '品类',
                uiKey: 'category',
                options: _categoryOptions,
              ),
              SizedBox(width: BrandFilterBarStyle.chipGap),
              _buildChip(
                context,
                label: '品牌',
                uiKey: 'brand',
                options: _brandOptions,
              ),
              SizedBox(width: BrandFilterBarStyle.chipGap),
              _buildChip(
                context,
                label: '规格',
                uiKey: 'spec',
                options: _specOptions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required String uiKey,
    required List<String> options,
  }) {
    return Obx(() {
      final currentValue = _currentFilterValue(uiKey);
      final isActive =
          (uiKey == 'sort' && controller.selectedSort.value != '默认') ||
          (uiKey == 'category' && controller.selectedSeries.value != '全部') ||
          (uiKey == 'brand' && controller.selectedYear.value != '全部') ||
          (uiKey == 'spec' && controller.selectedScale.value != '全部');

      final choiceItems = options
          .map((o) => S2Choice<String>(value: o, title: o))
          .toList();

      return SmartSelect<String>.single(
        title: label,
        selectedValue: currentValue,
        choiceItems: choiceItems,
        modalType: S2ModalType.bottomSheet,
        choiceType: S2ChoiceType.radios,
        onChange: (selected) {
          final v = selected.value;
          if (v != null) {
            Future.delayed(const Duration(milliseconds: 350), () {
              _onFilterChanged(uiKey, v);
            });
          }
        },
        tileBuilder: (ctx, state) {
          return GestureDetector(
            onTap: state.showModal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? context.color(mxt.color.primary)
                      : context.color(mxt.color.outline),
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isActive ? currentValue : label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isActive
                          ? context.color(mxt.color.primary)
                          : context.color(mxt.color.onSurface).withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: isActive
                        ? context.color(mxt.color.primary)
                        : context.color(mxt.color.onSurface).withOpacity(0.6),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
