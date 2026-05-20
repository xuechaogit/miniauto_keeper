import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:mix/mix.dart';
import '../../core/widgets/image/image.dart';
import 'controller.dart';
import 'style.dart';
import 'widget/gallery/gallery.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPECIFICATION / 商品详情'), elevation: 0),
      body: Obx(() {
        final data = controller.product.value;
        if (data == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE54335)),
          );
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageGallery(data: data),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
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
                  const Text(
                    "¥ ",
                    style: TextStyle(
                      color: Color(0xFFE54335),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${data.price}",
                    style: const TextStyle(
                      color: Color(0xFFE54335),
                      fontSize: 28,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Text(
                "// ",
                style: TextStyle(
                  color: Color(0xFFE54335),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                data.brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                "SCALE ${data.scale}",
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const Divider(color: Color(0xFF2C2C2C), height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "REF NO: ${data.itemNumber}",
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                "STOCK: ${data.stock} Pcs",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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
          const Text(
            "DATA ANALYSIS / 规格看板",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
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
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.technicalSpecs[key] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
          const Text(
            "OVERVIEW / 详情描述",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            data.description,
            style: const TextStyle(
              color: Color(0xFFD1D1D6),
              fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          const SizedBox(width: 8), // 紧凑的工业间距
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
              child: const Icon(
                Icons.ios_share_outlined, // 极简的出海通用分享图标
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

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
                child: const Text(
                  "EXECUTE PROCUREMENT / 立即提货",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.5,
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
