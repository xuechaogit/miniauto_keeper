import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/utils/screen_adapter.dart';
import 'package:miniauto_keeper/core/widgets/input/input.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.dart';
import 'package:miniauto_keeper/core/widgets/social_button/social_button.variant.dart';

import '../login/view.dart'; // 复用 LoginMixStyles
import '../login/widgets/login_label/login_label.dart';
import 'controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部返回
              HBox(
                style: Style(
                  $box.width(double.infinity),
                  $flex.mainAxisAlignment.start(),
                ),
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: h(16)),
              StyledText(
                'Create Account',
                style: Style(
                  $text.style.fontSize(sp(28)),
                  $text.style.fontWeight.w900(),
                  $text.style.letterSpacing(1.0),
                ),
              ),
              StyledText(
                'Join the collection family',
                style: Style($text.style.ref(mxt.textStyle.headline3)),
              ),
              SizedBox(height: h(24)),

              Box(
                style: LoginMixStyles.loginCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginLabel('Email Address'),
                    SizedBox(height: h(8)),
                    CustomInput(
                      controller: controller.emailController,
                      hint: 'collector@example.com',
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: h(16)),

                    const LoginLabel('Verification Code'),
                    SizedBox(height: h(8)),
                    HBox(
                      style: Style($flex.crossAxisAlignment.center()),
                      children: [
                        Expanded(
                          child: CustomInput(
                            controller: controller.codeController,
                            hint: '6-digit code',
                            icon: Icons.sms_outlined,
                          ),
                        ),
                        SizedBox(width: w(10)),
                        Obx(() {
                          final countdown = controller.codeCountdown.value;
                          final sending = controller.isCodeLoading.value;
                          return TextButton(
                            onPressed: controller.canSendCode && !sending
                                ? controller.sendCode
                                : null,
                            child: Text(
                              sending
                                  ? 'Sending...'
                                  : countdown > 0
                                  ? 'Resend (${countdown}s)'
                                  : 'Send',
                              style: const TextStyle(
                                color: Color(0xFFE52E1D),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: h(16)),

                    const LoginLabel('Password'),
                    SizedBox(height: h(8)),
                    Obx(
                      () => CustomInput(
                        controller: controller.passwordController,
                        hint: 'At least 6 characters',
                        icon: Icons.lock_outline_rounded,
                        obscureText: !controller.isPasswordVisible.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: r(20),
                          ),
                          onPressed: controller.isPasswordVisible.toggle,
                        ),
                      ),
                    ),
                    SizedBox(height: h(16)),

                    const LoginLabel('Confirm Password'),
                    SizedBox(height: h(8)),
                    Obx(
                      () => CustomInput(
                        controller: controller.confirmController,
                        hint: 'Repeat password',
                        icon: Icons.lock_rounded,
                        obscureText: !controller.isPasswordVisible.value,
                      ),
                    ),
                    SizedBox(height: h(16)),

                    const LoginLabel('Nickname (optional)'),
                    SizedBox(height: h(8)),
                    CustomInput(
                      controller: controller.nicknameController,
                      hint: 'e.g. 车模收藏家',
                      icon: Icons.badge_outlined,
                    ),
                    SizedBox(height: h(28)),

                    Obx(
                      () => Box(
                        style: Style($box.width(double.infinity)),
                        child: SocialButton(
                          onTap: controller.register,
                          loading: controller.isLoading.value,
                          type: SocialButtonTypeVariant.primary,
                          size: SocialButtonSizeVariant.defaults,
                          suffixIcon: Icons.arrow_forward_rounded,
                          label: 'Create Account',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
