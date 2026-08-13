import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/snackbar_util.dart';
import '../../../core/widgets/brand_selector/brand_selector.dart';
import '../../../core/widgets/form/form_builder/form_field_config.dart';
import '../../../models/brand_model.dart';

enum BrandFieldKind { model, car }

/// 本地分组结构，仅用于 report_missing 模块内部组织字段。
class ReportFieldSection {
  final String title;
  final List<FormFieldConfig> fields;

  const ReportFieldSection({required this.title, required this.fields});
}

class ReportMissingController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // ── 模拟品牌数据 ──
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
    '1:12',
    '1:18',
    '1:24',
    '1:43',
    '1:64',
    '1:87',
    '其他',
  ];
  static const versionOptions = ['普通版', '限定版', '特别版', '初回限定', '店铺限定', '展会限定'];
  static const colorOptions = [
    '白色',
    '黑色',
    '红色',
    '蓝色',
    '黄色',
    '绿色',
    '银色',
    '灰色',
    '多色',
  ];
  static const materialOptions = ['合金', '树脂', '塑料', '复合材料'];
  static const limitedOptions = [
    '不限量',
    '限量500',
    '限量1000',
    '限量2000',
    '限量3000',
    '限量5000',
    '限量10000',
  ];

  // ── 字段配置（分组） ──
  static final sections = [
    ReportFieldSection(
      title: '基本信息',
      fields: const [
        FormFieldConfig(
          type: FormFieldType.text,
          key: 'productName',
          label: '车模名称',
          hint: '请输入车模名称',
          isRequired: true,
        ),
        FormFieldConfig(
          type: FormFieldType.brand,
          key: 'modelBrand',
          label: '车模品牌',
          extra: BrandFieldKind.model,
        ),
        FormFieldConfig(
          type: FormFieldType.brand,
          key: 'carBrand',
          label: '汽车品牌',
          isRequired: true,
          extra: BrandFieldKind.car,
        ),
        FormFieldConfig(
          type: FormFieldType.text,
          key: 'releaseYear',
          label: '发行年份',
          hint: '如 2024',
          isRequired: true,
          keyboardType: TextInputType.number,
        ),
      ],
    ),
    ReportFieldSection(
      title: '规格详情',
      fields: const [
        FormFieldConfig(
          type: FormFieldType.select,
          key: 'scale',
          label: '比例',
          pickOptions: scaleOptions,
          isRequired: true,
        ),
        FormFieldConfig(
          type: FormFieldType.text,
          key: 'productCode',
          label: '车模编号',
          isRequired: true,
          hint: '如 ABC123',
        ),
        FormFieldConfig(
          type: FormFieldType.select,
          key: 'version',
          label: '版本',
          isRequired: true,
          pickOptions: versionOptions,
        ),
        FormFieldConfig(
          type: FormFieldType.select,
          key: 'color',
          label: '颜色',
          pickOptions: colorOptions,
        ),
        FormFieldConfig(
          type: FormFieldType.select,
          key: 'material',
          label: '材质',
          pickOptions: materialOptions,
        ),
        FormFieldConfig(
          type: FormFieldType.select,
          key: 'limitedInfo',
          label: '限量信息',
          pickOptions: limitedOptions,
        ),
        FormFieldConfig(
          type: FormFieldType.text,
          key: 'releasePrice',
          label: '发售价',
          hint: '如 299.00',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    ),
  ];

  // ── 表单状态 ──
  final images = <File>[].obs;
  final formValues = <String, dynamic>{}.obs;

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
  Future<void> selectBrand(BrandFieldKind kind) async {
    final title = kind == BrandFieldKind.model ? '选择车模品牌' : '选择汽车品牌';
    final key = kind == BrandFieldKind.model ? 'modelBrand' : 'carBrand';
    final result = await showBrandSelectorSheet(
      brands: mockBrands,
      title: title,
    );
    if (result != null) formValues[key] = result;
  }

  // ── 提交流水 ──
  /// 合并各 FormBuilder 的收集结果，走校验与提交。
  void onFormSubmit(Map<String, dynamic> values) {
    formValues.addAll(values);
    SnackBarUtil.primary('缺失商品已上报');
    Get.back();
  }
}
