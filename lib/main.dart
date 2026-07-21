import 'dart:ui';

import 'package:flutter/material.dart';
import 'core/utils/screen_adapter.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';

import 'core/services/settings_service.dart';
import 'core/l10n/arb/app_localizations.dart';
import 'core/services/storage_service.dart';
//主题色
import 'core/theme/app_mix_themes.dart';
import 'core/theme/app_theme.dart';
//页面
import 'modules/home/view.dart';
//路由
import 'core/router/app_pages.dart';
//网络
import 'core/network/http_service.dart';
//mix
// import 'package:mix/mix.dart';
import 'core/theme/app_theme_tool.dart';
import 'modules/main/view.dart'; // 导入我们之前的扩展

void main() async {
  // 1. 必须先初始化 Flutter 绑定
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 初始化持久化层（Hive）
  await Get.putAsync(() async => StorageService());
  await StorageService.init(); // 确保 Box 已打开

  // 3. 初始化设置服务
  await Get.putAsync(() => HttpService().init());

  // 4. 异步注入 Service 并等待它初始化完成
  // 使用 putAsync 配合内部的 init 逻辑
  await Get.putAsync(() => SettingsService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return Obx(() {
      final isDark = settings.isDarkMode;
      print('isDark $isDark');
      return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MixTheme(
          data: isDark ? darkTheme : lightTheme,
          child: GetMaterialApp(
          title: 'Flutter Demo',
          //开启
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
            },
          ),
          //国际化
          locale: Locale(settings.language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          //主体化
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: convertMixToThemeData(lightTheme, Brightness.light),
          darkTheme: convertMixToThemeData(darkTheme, Brightness.dark),
          // theme: ThemeData(brightness: Brightness.light),
          // darkTheme: ThemeData(brightness: Brightness.dark),
          //路由
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          //
          // home: const MainView(),
          ),
        ),
      );
    });
  }
}
