import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/widgets/input/input.dart';
import '../login/view.dart'; // 引入你的 LoginMixStyles
import '../login/widgets/login_label/login_label.dart';
import 'controller.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PRECISION HUB')),
      body: Stack(
        children: [
          _buildBackground(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Box(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: w(24.0)),
                  child: Box(
                    style: LoginMixStyles.loginCard,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          'Reset Password',
                          style: Style(
                            $text.style.fontSize(28),
                            $text.style.fontWeight.w800(),
                          ),
                        ),
                        SizedBox(height: h(12)),
                        Text(
                          'Enter your email to receive a reset link. We\'ll help you get back to your collection.',
                          style: TextStyle(fontSize: sp(14)),
                        ),
                        SizedBox(height: h(32)),
                        const LoginLabel('Email Address'),

                        SizedBox(height: h(8)),
                        CustomInput(
                          controller: controller.emailController,
                          hint: 'collector@apex.com',
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: h(32)),
                        _buildSubmitButton(
                          'Send Reset Link',
                          Icons.send_rounded,
                          controller.sendResetLink,
                        ),
                        SizedBox(height: h(32)),
                        _buildBackToLogin(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: h(32)),
              // _buildFooterSupport(),
            ],
          ),
        ],
      ),
    );
  }

  // 复用登录页的背景光晕
  Widget _buildBackground(BuildContext context) {
    return Positioned(
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
    );
  }

  Widget _buildSubmitButton(String label, IconData icon, VoidCallback tap) {
    return Pressable(
      onPress: tap,
      child: Box(
        style: LoginMixStyles.loginButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StyledText(label),
            SizedBox(width: w(8)),
            Icon(icon, color: Colors.white, size: r(18)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackToLogin() {
    return Center(
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, size: r(16)),
            SizedBox(width: w(8)),
            Text(
              'Back to Login',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSupport() {
    return Padding(
      padding: EdgeInsets.only(bottom: h(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Need technical assistance? ',
            style: TextStyle(fontSize: sp(14)),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Contact Support',
              style: TextStyle(color: Colors.blueAccent, fontSize: sp(12)),
            ),
          ),
        ],
      ),
    );
  }
}
