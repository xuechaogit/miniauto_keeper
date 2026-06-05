import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class SplashController extends GetxController {
  late File file;
  late RiveWidgetController riveController;
  RxBool isInitialized = false.obs;

  TriggerInput? p20, p40, p60, p80, p100;

  @override
  void onInit() {
    super.onInit();
    initRive();
  }

  Future<void> initRive() async {
    // 1️⃣ 加载 Rive 文件
    file = (await File.asset(
      'assets/animations/car_charging.riv',
      riveFactory: Factory.rive,
    ))!;

    // 2️⃣ 创建控制器
    riveController = RiveWidgetController(file);

    isInitialized.value = true;

    final machine = riveController.stateMachine;

    if (machine != null) {
      p20 = machine.inputs.firstWhere((e) => e.name == '20p') as TriggerInput;
      p40 = machine.inputs.firstWhere((e) => e.name == '40p') as TriggerInput;
      p60 = machine.inputs.firstWhere((e) => e.name == '60p') as TriggerInput;
      p80 = machine.inputs.firstWhere((e) => e.name == '80p') as TriggerInput;
      p100 = machine.inputs.firstWhere((e) => e.name == '100p') as TriggerInput;
    }

    //启动动画
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    p20!.fire();
    await Future.delayed(const Duration(milliseconds: 300));

    p40!.fire();
    await Future.delayed(const Duration(milliseconds: 300));

    p60?.fire();
    await Future.delayed(const Duration(milliseconds: 300));

    p80?.fire();
    await Future.delayed(const Duration(milliseconds: 300));

    p100?.fire();

    await Future.delayed(const Duration(milliseconds: 1500));

    Get.offAllNamed('/');
  }

  @override
  void dispose() {
    file.dispose();
    riveController.dispose();
    super.dispose();
  }
}
