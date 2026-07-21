import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import '../../controller.dart'; // 引入 NoticeModel
import 'notice_item.style.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class NoticeItem extends StatelessWidget {
  final NoticeModel notice;
  final VoidCallback onTap;

  const NoticeItem({Key? key, required this.notice, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Box(
        style: NoticeItemStyles.cardMix,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StyledText(
                    notice.title,
                    style: NoticeItemStyles.titleText,
                  ),
                ),
              ],
            ),
            SizedBox(height: h(8)),
            StyledText(notice.content, style: NoticeItemStyles.previewText),
            SizedBox(height: h(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StyledText(
                  'REF//${notice.id.padLeft(4, '0')}',
                  style: NoticeItemStyles.metaText,
                ),
                StyledText(notice.date, style: NoticeItemStyles.metaText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
