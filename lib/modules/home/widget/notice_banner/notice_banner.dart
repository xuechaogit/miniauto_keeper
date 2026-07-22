import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';

import '../../../../core/utils/screen_adapter.dart';
import '../../controller.dart';
import 'notice_banner.style.dart';

class NoticeBanner extends StatelessWidget {
  final HomeController controller;

  const NoticeBanner({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.notices;
      if (list.isEmpty) return const SizedBox.shrink();

      return Box(
        style: NoticeBannerStyle.container,
        child: Row(
          children: [
            Box(
              style: NoticeBannerStyle.logo,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
            SizedBox(width: w(10)),
            Expanded(
              child: FlutterCarousel.builder(
                itemCount: list.length,
                options: FlutterCarouselOptions(
                  height: h(24),
                  scrollDirection: Axis.vertical,
                  autoPlay: list.length > 1,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 1.0,
                  enableInfiniteScroll: list.length > 1,
                  showIndicator: false,
                  controller: controller.noticeCarouselController,
                ),
                itemBuilder: (context, index, _) {
                  final notice = list[index];
                  return GestureDetector(
                    onTap: () => Get.toNamed(
                      '/notice_detail',
                      arguments: {'id': notice.id, 'title': notice.title},
                    ),
                    child: Box(
                      style: NoticeBannerStyle.titleBox,
                      child: StyledText(
                        notice.title,
                        style: NoticeBannerStyle.titleText,
                      ),
                    ),
                  );
                },
              ),
            ),
            StyledIcon(
              Icons.chevron_right,
              style: NoticeBannerStyle.chevronIcon,
            ),
          ],
        ),
      );
    });
  }
}
