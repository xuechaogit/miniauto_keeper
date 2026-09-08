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
                options: () => _sortOptions,
              ),
              SizedBox(width: BrandFilterBarStyle.chipGap),
              _buildChip(
                context,
                label: '系列',
                uiKey: 'category',
                // 动态读取 controller.seriesOptions，系列加载完自动刷新
                options: () => controller.seriesOptions,
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
    required List<String> Function() options,
  }) {
    return Obx(() {
      final currentValue = _currentFilterValue(uiKey);
      final isActive =
          (uiKey == 'sort' && controller.selectedSort.value != '默认') ||
          (uiKey == 'category' && controller.selectedSeries.value != '全部');

      final choiceItems = options()
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
