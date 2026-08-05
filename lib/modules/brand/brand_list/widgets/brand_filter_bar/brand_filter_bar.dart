import 'package:flutter/material.dart';
import 'package:flutter_filter_dialog/flutter_filter_dialog.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:mix/mix.dart';

import '../../controller.dart';
import 'brand_filter_bar.style.dart';

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
    return Box(
      style: Style($box.width(double.infinity)),
      child: Box(
        style: BrandFilterBarStyle.barPadding,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HBox(
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
            child: Box(
              style: BrandFilterBarStyle.chipBase(isActive: isActive),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StyledText(
                    isActive ? currentValue : label,
                    style: BrandFilterBarStyle.chipText(isActive: isActive),
                  ),

                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: isActive
                        ? context.color(mxt.color.primary)
                        : context.color(mxt.color.onSurface),
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
