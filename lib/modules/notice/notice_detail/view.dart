import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide Style;
import 'package:get/get.dart';
import 'package:miniauto_keeper/core/widgets/html_renderer/html_renderer.dart';
import 'package:mix/mix.dart';
import 'package:mix/mix.dart' as flutter_html;

import '../../../core/theme/app_theme.dart';
import '../widget/notice_detail_skeleton/notice_skeleton_item.dart';
import 'controller.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class NoticeDetailStyles {
  static Style get contentText => Style(
    $text.color.ref(mxt.color.onSurface),
    $text.style.ref(mxt.textStyle.body),
    $text.style.height(1.6),
    $text.style.letterSpacing(0.3),
  );

  static Style get metaText => Style(
    $text.color.ref(mxt.color.onSurfaceVariant),
    $text.style.fontSize(11),
  );
}

class NoticeDetailView extends GetView<NoticeDetailController> {
  const NoticeDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NOTICE DETAILS'), elevation: 0),
      body: Box(
        child: Obx(() {
          // 1. 详情加载中的机械状态
          if (controller.isLoading.value) {
            return const NoticeDetailSkeleton();
          }

          final notice = controller.notice.value;

          // 2. 异常空状态
          if (notice == null || notice.title == 'NOT FOUND') {
            return Center(
              child: Text(
                notice?.content ?? 'ERR: NULL POINTER',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFE54335),
                  fontFamily: 'Courier',
                  height: 1.4,
                ),
              ),
            );
          }

          // 3. 核心正文渲染
          return SizedBox.expand(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(r(24.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StyledText(
                        'DATE // ${notice.date}',
                        style: NoticeDetailStyles.metaText,
                      ),
                      const Spacer(),
                      StyledText(
                        'ID // ${notice.id.padLeft(4, '0')}',
                        style: NoticeDetailStyles.metaText,
                      ),
                    ],
                  ),
                  SizedBox(height: h(16)),
                  Text(
                    notice.title,
                    style: TextStyle(
                      fontSize: sp(22),
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: h(12)),
                  Divider(height: 2),
                  SizedBox(height: h(24)),
                  // HTML 渲染核心部件
                  AppHtmlRenderer(
                    htmlContent: notice.content, // 扔进 HTML 字符串
                    onLinkTap: (url) {
                      print('url: $url');
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
