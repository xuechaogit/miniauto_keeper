import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as f_html;
import 'html_renderer.style.dart'; // 引入分离出的工业风样式表

class AppHtmlRenderer extends StatelessWidget {
  final String htmlContent;
  final void Function(String? url)? onLinkTap;

  const AppHtmlRenderer({Key? key, required this.htmlContent, this.onLinkTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 规避空数据传染导致解析器浪费性能
    if (htmlContent.isEmpty) {
      return const SizedBox.shrink();
    }

    return f_html.Html(
      data: htmlContent,
      // style: AppHtmlStyles.industrialTheme, // 丝滑注入抽离出的全局配置
      onLinkTap: (url, _, __) {
        if (onLinkTap != null) {
          onLinkTap!(url);
        } else {
          // 默认的底层调试台输出
          debugPrint('AppHtmlRenderer Clicked URL: $url');
        }
      },
    );
  }
}
