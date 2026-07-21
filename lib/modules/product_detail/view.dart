import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/widgets/image/image.dart';
import 'controller.dart';
import 'style.dart';
import 'widget/gallery/gallery.dart';

import 'package:miniauto_keeper/core/utils/screen_adapter.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPECIFICATION / 商品详情'), elevation: 0),
      body: Obx(() {
        final data = controller.product.value;
        if (data == null) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFFE54335)),
          );
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: h(90)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageGallery(data: data),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(12),
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        _buildCoreMetaCard(data),
                        _buildTechnicalSpecsGrid(data),
                        _buildDetailDescCard(data),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final data = controller.product.value;
        return data == null
            ? const SizedBox.shrink()
            : _buildBottomControlPanel();
      }),
    );
  }

  // 2. 核心价格、品牌、编号信息面板
  Widget _buildCoreMetaCard(data) {
    return Box(
      style: ProductDetailStyle.industrialCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "¥ ",
                    style: TextStyle(
                      color: Color(0xFFE54335),
                      fontSize: sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${data.price}",
                    style: TextStyle(
                      color: Color(0xFFE54335),
                      fontSize: sp(28),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              Box(
                style: ProductDetailStyle.statusTagRed,
                child: Text(
                  data.status,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sp(10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h(14)),
          Row(
            children: [
              Text(
                "// ",
                style: TextStyle(
                  color: Color(0xFFE54335),
                  fontWeight: FontWeight.bold,
                  fontSize: sp(16),
                ),
              ),
              Text(
                data.brand,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: sp(14),
                  fontWeight: FontWeight.bold,
                  letterSpacing: w(1),
                ),
              ),
              const Spacer(),
              Text(
                "SCALE ${data.scale}",
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: sp(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: h(8)),
          Text(
            data.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(18),
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          Divider(color: Color(0xFF2C2C2C), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "REF NO: ${data.itemNumber}",
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: sp(12),
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                "STOCK: ${data.stock} Pcs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: sp(12),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 3. 数字化仪表盘参数阵列
  Widget _buildTechnicalSpecsGrid(data) {
    final specKeys = data.technicalSpecs.keys.toList();
    return Box(
      style: ProductDetailStyle.industrialCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "DATA ANALYSIS / 规格看板",
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: w(1),
            ),
          ),
          SizedBox(height: h(12)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: specKeys.length,
            itemBuilder: (context, index) {
              final key = specKeys[index];
              return Box(
                style: ProductDetailStyle.specGridItem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: sp(11),
                      ),
                    ),
                    SizedBox(height: h(4)),
                    Text(
                      data.technicalSpecs[key] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: sp(12),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 4. 车款叙述详情
  Widget _buildDetailDescCard(data) {
    return Box(
      style: ProductDetailStyle.industrialCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "OVERVIEW / 详情描述",
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(12),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h(10)),
          Text(
            data.description,
            style: TextStyle(
              color: Color(0xFFD1D1D6),
              fontSize: sp(13),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // 5. 核心修改：使用 BottomAppBar 彻底重构底栏容器
  Widget _buildBottomControlPanel() {
    return BottomAppBar(
      height: 70, // 稍微拉高一点，给全面屏留出呼吸感
      elevation: 8,
      padding: EdgeInsets.symmetric(horizontal: w(16), vertical: 12),
      child: Row(
        children: [
          // 按钮一：收藏 (Obx 局部包裹状态)
          GestureDetector(
            onTap: controller.toggleStorageStatus,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              child: Obx(
                () => Icon(
                  controller.isStored.value
                      ? Icons.star_sharp
                      : Icons.star_border_sharp,
                  color: controller.isStored.value
                      ? const Color(0xFFE54335)
                      : Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: w(8)), // 紧凑的工业间距
          // 按钮二：🆕 国际化通用分享按钮
          GestureDetector(
            onTap: controller.executeShare, // 触发上面写好的分享
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              child: Icon(
                Icons.ios_share_outlined, // 极简的出海通用分享图标
                color: Colors.white,
                size: r(20),
              ),
            ),
          ),
          SizedBox(width: w(12)),

          // 按钮三：提货主操作
          Expanded(
            child: Pressable(
              onPress: () {
                Get.snackbar(
                  "SYSTEM",
                  "入库单生成中...",
                  backgroundColor: const Color(0xFFE54335),
                  colorText: Colors.white,
                );
              },
              child: Box(
                style: ProductDetailStyle.primaryActionBtn,
                child: Text(
                  "EXECUTE PROCUREMENT / 立即提货",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: sp(13),
                    letterSpacing: w(0.5),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
