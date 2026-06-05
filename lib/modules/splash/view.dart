import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_theme_tool.dart';
import 'controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: context.color(mxt.color.background),
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Center(
          child: SizedBox(
            width: screenWidth * 0.85,
            height: screenWidth * 0.85,
            child: Stack(
              children: [
                // 1️⃣ Rive 动画
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.86,
                    child: RiveWidget(
                      controller: controller.riveController,
                      fit: Fit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
