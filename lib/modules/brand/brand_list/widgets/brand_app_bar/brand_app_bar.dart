import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:mix/mix.dart';

import '../../controller.dart';

class BrandSearchBar extends GetView<BrandDetailController> {
  const BrandSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: HBox(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.color(mxt.color.onSurface),
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: context.textStyle(mxt.textStyle.body),
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: '搜索商品...',
                filled: true,
                fillColor: context.color(mxt.color.surfaceVariant),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.color(mxt.color.primary),
                  size: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    context.radius(mxt.radius.large),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
