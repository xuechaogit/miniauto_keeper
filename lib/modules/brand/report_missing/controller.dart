import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/snackbar_util.dart';
import '../../../core/widgets/brand_selector/brand_selector.dart';
import '../../../models/brand_model.dart';

class ReportMissingController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // ── 模拟品牌数据（车模品牌 & 汽车品牌共用） ──
  static final mockBrands = [
    BrandModel(id: 1, pid: 0, name: 'AUTOart', thumb: ''),
    BrandModel(id: 2, pid: 0, name: 'Minichamps', thumb: ''),
    BrandModel(id: 3, pid: 0, name: 'Kyosho', thumb: ''),
    BrandModel(id: 4, pid: 0, name: 'Tarmac Works', thumb: ''),
    BrandModel(id: 5, pid: 0, name: 'INNO64', thumb: ''),
    BrandModel(id: 6, pid: 0, name: 'Hot Wheels', thumb: ''),
    BrandModel(id: 7, pid: 0, name: 'Tomica Limited Vintage', thumb: ''),
    BrandModel(id: 8, pid: 0, name: 'Spark', thumb: ''),
    BrandModel(id: 9, pid: 0, name: 'Looksmart', thumb: ''),
    BrandModel(id: 10, pid: 0, name: 'BBR', thumb: ''),
    BrandModel(id: 11, pid: 0, name: 'Almost Real', thumb: ''),
    BrandModel(id: 12, pid: 0, name: 'LCD Models', thumb: ''),
    BrandModel(id: 13, pid: 0, name: 'Mini GT', thumb: ''),
    BrandModel(id: 14, pid: 0, name: 'Pop Race', thumb: ''),
    BrandModel(id: 15, pid: 0, name: 'CM Model', thumb: ''),
    BrandModel(id: 16, pid: 0, name: 'Hobby Japan', thumb: ''),
    BrandModel(id: 17, pid: 0, name: 'Peako', thumb: ''),
    BrandModel(id: 18, pid: 0, name: 'FrontiArt', thumb: ''),
    BrandModel(id: 19, pid: 0, name: 'GT Spirit', thumb: ''),
    BrandModel(id: 20, pid: 0, name: 'FuelMe', thumb: ''),
  ];

  // ── 固定枚举 ──
  static const scaleOptions = [
    '1:12', '1:18', '1:24', '1:43', '1:64', '1:87', '其他',
  ];
  static const versionOptions = [
    '普通版', '限定版', '特别版', '初回限定', '店铺限定', '展会限定',
  ];
  static const colorOptions = [
    '白色', '黑色', '红色', '蓝色', '黄色', '绿色', '银色', '灰色', '多色',
  ];
  static const materialOptions = [
    '合金', '树脂', '塑料', '复合材料',
  ];
  static const limitedOptions = [
    '不限量', '限量500', '限量1000', '限量2000', '限量3000', '限量5000', '限量10000',
  ];

  // ── 表单状态 ──
  final images = <File>[].obs;

  final modelBrand = Rxn<BrandModel>();
  final carBrand = Rxn<BrandModel>();
  final scale = ''.obs;
  final version = ''.obs;
  final color = ''.obs;
  final material = ''.obs;
  final limitedInfo = ''.obs;

  final productNameCtrl = TextEditingController();
  final releaseYearCtrl = TextEditingController();
  final productCodeCtrl = TextEditingController();
  final releasePriceCtrl = TextEditingController();

  // ── 图片操作 ──
  Future<void> pickImages() async {
    if (images.length >= 5) {
      SnackBarUtil.primary('最多上传5张图片');
      return;
    }

    try {
      final picked = await _picker.pickMultiImage();
      for (final xfile in picked) {
        if (images.length >= 5) break;
        images.add(File(xfile.path));
      }
    } catch (_) {}
  }

  void removeImage(int index) => images.removeAt(index);

  // ── 品牌选择 ──
  Future<void> selectModelBrand() async {
    final result = await showBrandSelectorSheet(
      brands: mockBrands,
      title: '选择车模品牌',
    );
    if (result != null) modelBrand.value = result;
  }

  Future<void> selectCarBrand() async {
    final result = await showBrandSelectorSheet(
      brands: mockBrands,
      title: '选择汽车品牌',
    );
    if (result != null) carBrand.value = result;
  }

  // ── 选择器回写 ──
  void onScaleChanged(String? value) {
    if (value != null) scale.value = value;
  }

  void onVersionChanged(String? value) {
    if (value != null) version.value = value;
  }

  void onColorChanged(String? value) {
    if (value != null) color.value = value;
  }

  void onMaterialChanged(String? value) {
    if (value != null) material.value = value;
  }

  void onLimitedChanged(String? value) {
    if (value != null) limitedInfo.value = value;
  }

  // ── 提交 ──
  void submit() {
    if (productNameCtrl.text.trim().isEmpty) {
      SnackBarUtil.primary('请输入车模名称');
      return;
    }
    if (modelBrand.value == null) {
      SnackBarUtil.primary('请选择车模品牌');
      return;
    }

    // 模拟提交
    SnackBarUtil.primary('缺失商品已上报');
    Get.back();
  }

  @override
  void onClose() {
    productNameCtrl.dispose();
    releaseYearCtrl.dispose();
    productCodeCtrl.dispose();
    releasePriceCtrl.dispose();
    super.onClose();
  }
}
