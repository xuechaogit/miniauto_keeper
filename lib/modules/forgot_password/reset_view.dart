import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/widgets/input/input.dart';
import '../login/view.dart';
import '../login/widgets/login_label/login_label.dart';
import 'controller.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

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
        padding: EdgeInsets.all(r(24.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Update',
              style: TextStyle(fontSize: sp(26), fontWeight: FontWeight.w800),
            ),
            const Text(
              'Create a strong, secure password to protect your collection.',
            ),
            SizedBox(height: h(40)),
            const LoginLabel('New Password'),
            SizedBox(height: h(8)),
            CustomInput(
              controller: controller.newPwdController,
              hint: 'New Password',
              icon: Icons.lock_outline,
            ),

            SizedBox(height: h(24)),
            const LoginLabel('Confirm New Password'),

            SizedBox(height: h(8)),
            CustomInput(
              controller: controller.confirmPwdController,
              hint: 'Confirm New Password',
              icon: Icons.refresh_rounded,
            ),

            SizedBox(height: h(40)),
            Text(
              'SECURITY REQUIREMENTS',
              style: TextStyle(
                fontSize: sp(12),
                letterSpacing: w(1.2),
                color: Colors.white38,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: h(16)),

            // _buildReqItem('At least 8 characters long', true),
            // _buildReqItem('Include at least one number', false),
            // _buildReqItem('Include one special character (!@#)', false),
            // SizedBox(height: h(60)),
            Pressable(
              onPress: controller.updatePassword,
              child: Box(
                style: LoginMixStyles.loginButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledText('Update Password'),
                    SizedBox(width: w(8)),
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: r(18),
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
      padding: EdgeInsets.only(bottom: h(12)),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: r(18),
            color: isMet ? Colors.greenAccent : Colors.white24,
          ),
          SizedBox(width: w(12)),
          Text(
            text,
            style: TextStyle(color: isMet ? Colors.white : Colors.white24),
          ),
        ],
      ),
    );
  }
}
