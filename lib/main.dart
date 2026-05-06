import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'core/services/settings_service.dart';
import 'core/l10n/arb/app_localizations.dart';
import 'core/services/storage_service.dart';
//主题色
import 'core/theme/app_theme.dart';
//页面
import 'modules/home/view.dart';
//路由
import 'core/router/app_pages.dart';
//网络
import 'core/network/request_client.dart';

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

    return GetMaterialApp(
      title: 'Flutter Demo',
      //国际化
      locale: Locale(settings.language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //主体化
      darkTheme: AppTheme.dark(Color(settings.themeColorValue)),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      //路由
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      // 1. 代理配置
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 关键：将内容提取到独立的 Widget 中
      home: const HomeView(),
    );
  }
}
