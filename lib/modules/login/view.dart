import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/app_logo/app_logo.dart';
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
    $box.padding.all.ref(mxt.space.large),
    $box.borderRadius(r(32)),
    $box.color.ref(mxt.color.surface),
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
    $box.borderRadius.all.ref(mxt.radius.small),
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
              width: w(300),
              height: h(300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE52E1D).withOpacity(0.05),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w(12)),
              child: Column(
                children: [
                  // --- 顶部返回按钮 ---
                  HBox(
                    style: Style(
                      $box.width(double.infinity),
                      $flex.mainAxisAlignment.start(),
                    ),
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Get.back(), // 使用 GetX 返回
                      ),
                    ],
                  ),

                  // --- Logo 区域 ---
                  Box(
                    style: Style(
                      $box.width(w(86)),
                      $box.height(w(86)),
                      $box.borderRadius(r(12)),
                      $box.padding.all(w(8)),
                      $box.color.ref(mxt.color.background),
                      $box.alignment.center(),
                    ),
                    child: AppLogo(),
                  ),
                  SizedBox(height: h(24)),
                  StyledText(
                    'PRECISION HUB',
                    style: Style(
                      $text.style.fontSize(sp(28)),
                      $text.style.fontWeight.w900(),
                      $text.style.letterSpacing(1.5),
                    ),
                  ),
                  StyledText(
                    'Elevate Your Collection',
                    style: Style($text.style.ref(mxt.textStyle.headline3)),
                  ),

                  SizedBox(height: h(32)),

                  // --- 登录卡片区域 ---
                  Box(
                    style: LoginMixStyles.loginCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoginLabel('Email Address'),
                        SizedBox(height: h(12)),
                        CustomInput(
                          controller: controller.emailController,
                          hint: 'collector@precision.com',
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: h(20)),
                        HBox(
                          style: Style(
                            $flex.mainAxisAlignment.spaceBetween(),
                            $flex.crossAxisAlignment.center(),
                          ),
                          children: [
                            const LoginLabel('Password'),
                            _buildForgotButton(), // 忘记密码按钮
                          ],
                        ),
                        SizedBox(height: h(12)),
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

                                size: r(20),
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                        ),
                        SizedBox(height: h(32)),

                        // 登录按钮 (带加载状态)
                        _buildLoginButton(),

                        SizedBox(height: h(28)),
                        Center(
                          child: StyledText(
                            'OR CONTINUE WITH',
                            style: Style(
                              $text.style.ref(mxt.textStyle.body),
                              $text.color.ref(mxt.color.onSurface),
                            ),
                          ),
                        ),
                        SizedBox(height: h(24)),

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
                            SizedBox(width: w(16)),
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

                  SizedBox(height: h(32)),
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
        ],
      ),
    );
  }

  // 组件：通用输入框
  Widget _buildForgotButton() {
    return GestureDetector(
      onTap: () {
        // 这里跳转到忘记密码页面，或者弹出提示
        Get.toNamed(AppRoutes.forgotPassword);
      },
      child: StyledText(
        'Forgot Password?',
        style: Style(
          $text.color.ref(mxt.color.primary),
          $text.style.ref(mxt.textStyle.body),
          $text.style.fontWeight.w600(),
        ),
      ),
    );
  }

  // 组件：带状态的登录按钮
  Widget _buildLoginButton() {
    return Obx(
      () => Pressable(
        onPress: controller.isLoading.value ? null : () => controller.login(),
        child: Box(
          style: LoginMixStyles.loginButton,
          child: controller.isLoading.value
              ? SizedBox(
                  width: w(24),
                  height: h(24),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText('Login to Hub'),
                    SizedBox(width: w(10)),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: r(20),
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
