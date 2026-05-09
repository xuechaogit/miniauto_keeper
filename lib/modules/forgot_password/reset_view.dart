import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/widgets/input/input.dart';
import '../login/view.dart';
import '../login/widgets/login_label/login_label.dart';
import 'controller.dart';

class SetNewPasswordView extends GetView<ForgotPasswordController> {
  const SetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Set New Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security Update',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const Text(
              'Create a strong, secure password to protect your collection.',
            ),
            const SizedBox(height: 40),
            const LoginLabel('New Password'),
            const SizedBox(height: 8),
            CustomInput(
              controller: controller.newPwdController,
              hint: 'New Password',
              icon: Icons.lock_outline,
            ),

            const SizedBox(height: 24),
            const LoginLabel('Confirm New Password'),

            const SizedBox(height: 8),
            CustomInput(
              controller: controller.confirmPwdController,
              hint: 'Confirm New Password',
              icon: Icons.refresh_rounded,
            ),

            const SizedBox(height: 40),
            const Text(
              'SECURITY REQUIREMENTS',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                color: Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 16),

            // _buildReqItem('At least 8 characters long', true),
            // _buildReqItem('Include at least one number', false),
            // _buildReqItem('Include one special character (!@#)', false),
            // const SizedBox(height: 60),
            Pressable(
              onPress: controller.updatePassword,
              child: Box(
                style: LoginMixStyles.loginButton,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText('Update Password'),
                    SizedBox(width: 8),
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReqItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: isMet ? Colors.greenAccent : Colors.white24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: isMet ? Colors.white : Colors.white24),
          ),
        ],
      ),
    );
  }
}
