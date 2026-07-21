import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/theme/app_theme_tool.dart';
import 'package:mix/mix.dart';
import 'package:pinput/pinput.dart'; // 导入 pinput
import '../../core/theme/app_theme.dart';
import '../login/view.dart';
import 'controller.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class VerifyIdentityView extends GetView<ForgotPasswordController> {
  const VerifyIdentityView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. 基础样式 (根据主题调整背景和边框)
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 65,
      textStyle: TextStyle(
        fontSize: sp(24),
        fontWeight: FontWeight.bold,
        // 动态文字颜色：暗色模式白色，亮色模式黑色
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: BoxDecoration(
        // 动态背景：暗色模式透明白，亮色模式透明黑或灰色
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
      ),
    );

    // 2. 聚焦状态 (通常保持主色调，如你的 0xFFFFB4AB)
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: context.color(mxt.color.primary)),
      ),
    );

    // 3. 错误状态
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: context.color(mxt.color.onErrorContainer)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Verify Identity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(r(24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We've sent a 6-digit code to your email",
              style: TextStyle(fontSize: sp(16)),
            ),
            SizedBox(height: h(32)),
            Text(
              controller.emailController.text,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h(16)),

            // --- 优化后的验证码输入组件 ---
            Center(
              child: Pinput(
                length: 6,
                controller: controller.otpController, // 控制器里改为单个 controller
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onCompleted: (pin) => controller.verifyCode(pin), // 输完自动触发验证
                hapticFeedbackType: HapticFeedbackType.lightImpact, // 触感反馈
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 让它看起来更像你的 Mix 风格
                separatorBuilder: (index) => SizedBox(width: w(8)),
              ),
            ),

            SizedBox(height: h(16)),
            Center(
              child: Text(
                'Check your spam folder if you don\'t see it.',
                style: TextStyle(fontSize: sp(13)),
              ),
            ),
            const Spacer(),

            Pressable(
              onPress: () =>
                  controller.verifyCode(controller.otpController.text),
              child: Box(
                style: LoginMixStyles.loginButton,
                child: const Center(child: StyledText('Verify and Continue')),
              ),
            ),
            SizedBox(height: h(24)),
            _buildResendSection(),
            SizedBox(height: h(20)),
          ],
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Resend Code',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: h(8)),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_outlined, size: r(16)),
                SizedBox(width: w(4)),
                Text(
                  'Resend in 0:${controller.timer.value.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
