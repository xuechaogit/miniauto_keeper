import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'core/l10n/arb/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      //国际化
      locale: const Locale('zh'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // 1. 代理配置
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      // 关键：将内容提取到独立的 Widget 中
      home: const HomeView(),
    );
  }
}

// 拆分后的首页
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 此时 context 处于 GetMaterialApp 之下，可以正常拿到数据
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName), // 这里就能拿到“车仔助手”了
      ),
      body: Center(child: Text(l10n.homeTitle)),
    );
  }
}
