import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as f_html;

class AppHtmlStyles {
  /// 全应用统一的赛车工业感 Dark 风格 HTML 全景主题样式表
  static Map<String, f_html.Style> get industrialTheme => {
    // 基础正文排版（高级铁灰）
    "body": f_html.Style(
      color: const Color(0xFFDDDDDD),
      fontSize: f_html.FontSize(15),
      lineHeight: f_html.LineHeight(1.6),
      letterSpacing: 0.3,
      padding: f_html.HtmlPaddings.zero,
      margin: f_html.Margins.zero,
      fontFamily: 'sans-serif',
    ),
    // 段落垂直落差
    "p": f_html.Style(margin: f_html.Margins.only(bottom: 16)),
    // 纯白加粗，视觉冲击力强
    "strong": f_html.Style(
      color: const Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
    // 赛车红高亮超链接
    "a": f_html.Style(
      color: const Color(0xFFE54335),
      textDecoration: TextDecoration.underline,
    ),
    // 工业序列码/技术参数专用的黑红等宽代码块
    "code": f_html.Style(
      fontFamily: 'Courier',
      backgroundColor: const Color(0xFF2C2C2C),
      color: const Color(0xFFE54335),
      padding: f_html.HtmlPaddings.symmetric(horizontal: 6, vertical: 2),
    ),
    // 富文本内部的无序列表
    "ul": f_html.Style(
      padding: f_html.HtmlPaddings.only(left: 20),
      margin: f_html.Margins.only(bottom: 16),
    ),
    // 列表单项排版
    "li": f_html.Style(
      margin: f_html.Margins.only(bottom: 6),
      lineHeight: f_html.LineHeight(1.4),
    ),
  };
}
