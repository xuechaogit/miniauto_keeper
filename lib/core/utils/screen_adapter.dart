// 屏幕适配工具：避免 flutter_screenutil 与 mix 的 num 扩展方法冲突
// 显式调用 ScreenUtil 静态方法，不使用 .w/.h/.sp/.r 扩展
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;

/// 屏幕适配初始化（在 main.dart 中调用）
void initScreenAdapter(BuildContext context) {
  ScreenUtil.init(context, designSize: const Size(390, 844));
}

/// 根据设计稿宽度比例缩放
double w(double width) => ScreenUtil().setWidth(width);

/// 根据设计稿高度比例缩放
double h(double height) => ScreenUtil().setHeight(height);

/// 字体大小缩放（同时适配系统字体设置）
double sp(double fontSize) => ScreenUtil().setSp(fontSize);

/// 圆角等取 w 和 h 中较小比例缩放，保证圆形不变形
double r(double radius) => ScreenUtil().radius(radius);
