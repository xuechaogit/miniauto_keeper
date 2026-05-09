import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/input/input.dart';
import 'controller.dart';

import 'widgets/login_label/login_label.dart';
import 'widgets/social_button/social_button.dart';

/// 1. 定义专属登录页的 Mix 样式，保持代码整洁
class LoginMixStyles {
  // 玻璃拟态卡片容器
  static Style get loginCard => Style(
    $box.padding.all(32),
    $box.borderRadius(32),
    $box.color.white.withOpacity(0.05),
    $box.border.color.ref(mxt.color.outline),
    $box.border.all(width: 1),

    $box.decoration.gradient.linear(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white.withOpacity(0.08), Colors.transparent],
    ),
  );

  // 红色主登录按钮（带红色发光阴影）
  static Style get loginButton => Style(
    $box.height(58),
    $box.borderRadius.all.ref(mxt.radius.medium),
    $box.color.ref(mxt.color.primary),
    $box.alignment.center(),

    // $box.shadow.color.ref(mxt.color.primary),
    // $box.shadow.blurRadius(10),
    // $box.shadow.offset(0, 10),
    $text.style.color.white(),
    $text.style.fontWeight.w700(),
    $text.style.fontSize(16),
    $text.style.letterSpacing(0.5),
  );
}

/// 2. LoginView 完整实现
class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 顶部背景氛围装饰（可选：增加一点红色光晕）
          Positioned(
            top: -100,
            left: context.width * 0.2,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE52E1D).withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // --- Logo 区域 ---
                  Box(
                    style: Style(
                      $box.width(86),
                      $box.height(86),
                      $box.borderRadius(20),
                      $box.color.black.withOpacity(0.6),
                      $box.border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      $box.alignment.center(),
                    ),
                    child: const Icon(
                      Icons.precision_manufacturing_rounded,
                      color: Color(0xFFE52E1D),
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 24),
                  StyledText(
                    'PRECISION HUB',
                    style: Style(
                      $text.style.fontSize(34),
                      $text.style.fontWeight.w900(),
                      $text.style.letterSpacing(1.5),
                    ),
                  ),
                  StyledText(
                    'Elevate Your Collection',
                    style: Style($text.style.fontSize(15)),
                  ),

                  const SizedBox(height: 48),

                  // --- 登录卡片区域 ---
                  Box(
                    style: LoginMixStyles.loginCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoginLabel('Email Address'),
                        CustomInput(
                          controller: controller.emailController,
                          hint: 'collector@precision.com',
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const LoginLabel('Password'),
                            _buildForgotButton(), // 忘记密码按钮
                          ],
                        ),
                        Obx(
                          () => CustomInput(
                            controller: controller.passwordController,
                            hint: '••••••••',
                            icon: Icons.lock_outline_rounded,
                            obscureText: !controller.isPasswordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,

                                size: 20,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // 登录按钮 (带加载状态)
                        _buildLoginButton(),

                        const SizedBox(height: 28),
                        const Center(
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 第三方登录按钮组
                        Row(
                          children: [
                            Expanded(
                              child: SocialButton(
                                icon: Icons.g_mobiledata_rounded,
                                label: 'Google',
                                onTap: () => controller
                                    .loginWithGoogle(), // 在 controller 里实现
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SocialButton(
                                icon: Icons.apple_rounded,
                                label: 'Apple',
                                onTap: () => controller.loginWithApple(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  // 底部注册跳转
                  _buildBottomLink('New collector? ', 'Create Account', () {
                    Get.toNamed('/register');
                  }),
                  // const SizedBox(height: 40),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _buildFooterLink('Privacy Policy'),
                  //     const SizedBox(width: 32),
                  //     _buildFooterLink('Terms of Service'),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          Positioned(
            top: 10, // 根据需要微调
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Get.back(), // 使用 GetX 返回
            ),
          ),
        ],
      ),
    );
  }

  // 组件：通用输入框
  Widget _buildForgotButton() {
    return Padding(
      // 稍微向上偏移一点，与 Label 对齐感更强
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          // 这里跳转到忘记密码页面，或者弹出提示
          Get.toNamed(AppRoutes.forgotPassword);
        },
        child: StyledText(
          'Forgot Password?',
          style: Style(
            $text.style.color(Colors.blueAccent),
            $text.style.fontSize(12),
            $text.style.fontWeight.w600(),
          ),
        ),
      ),
    );
  }

  // 组件：带状态的登录按钮
  Widget _buildLoginButton() {
    return Pressable(
      onPress: controller.login,
      child: Obx(
        () => Box(
          style: LoginMixStyles.loginButton,
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText('Login to Hub'),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildBottomLink(String pre, String link, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          Text(pre),
          Text(
            link,
            style: const TextStyle(
              color: Color(0xFFE52E1D),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
