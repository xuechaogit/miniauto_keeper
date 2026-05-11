import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'header_card.clipper.dart';
import 'header_card.style.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;

  const ProfileHeaderCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            // 底层：颜色边框
            ClipPath(clipper: GTAeroClipper(), child: Container()),
            // 内容层
            Padding(
              padding: const EdgeInsets.all(1.5),
              child: ClipPath(
                clipper: GTAeroClipper(),
                child: Box(
                  style: HeaderCardStyle.container,
                  child: _buildBody(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  name.toUpperCase(),
                  style: HeaderCardStyle.driverName,
                ),
                const SizedBox(height: 10),
                StyledText(
                  'GT3 • TRACK MODE ACTIVE',
                  style: HeaderCardStyle.statusText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(color: primaryColor.withOpacity(0.6), width: 1.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // CircularProgressIndicator(
          //   value: 0.72,
          //   strokeWidth: 2,
          //   // valueColor: AlwaysStoppedAnimation(primaryColor.withOpacity(0.7)),
          //   backgroundColor: Colors.white10,
          // ),
          const CircleAvatar(
            radius: 29,
            backgroundColor: Color(0xFF151515),
            backgroundImage: NetworkImage(
              'https://api.dicebear.com/7.x/bottts/png?seed=Collector',
            ),
          ),
        ],
      ),
    );
  }
}
