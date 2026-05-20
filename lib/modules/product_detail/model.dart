class ProductMockModel {
  final String id;
  final String brand; // 品牌，如 MINI GT / Inno64
  final String name; // 车款名称
  final String itemNumber; // 厂方编号
  final String scale; // 比例 1:64
  final double price; // 批发/分销价
  final int stock; // 库存数量
  final String status; // 状态：预售/现货
  final String description; // 详细描述
  final List<String> images; // 图片占位符
  final Map<String, String> technicalSpecs; // 工业技术参数

  ProductMockModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.itemNumber,
    required this.scale,
    required this.price,
    required this.stock,
    required this.status,
    required this.description,
    required this.images,
    required this.technicalSpecs,
  });

  // 生成模拟数据的静态方法
  static ProductMockModel getMockData() {
    return ProductMockModel(
      id: "100234",
      brand: "MINI GT",
      name: "Nissan Skyline GT-R R34 Top Secret Orion Green",
      itemNumber: "MGT00682-L",
      scale: "1:64",
      price: 138.00,
      stock: 42,
      status: "现货 AVAILABLE",
      description:
          "本款为 Top Secret 经典大魔王全包围改装涂装，合金底盘，超顺滑橡胶轮胎。车身采用独家金属极光绿烤漆，完美复刻原车肌肉线条与碳纤维尾翼细节。",
      images: [
        "https://images.unsplash.com/photo-1617788138017-80ad40651399?w=500", // 占位图
        "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=500",
        "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=500",
      ],
      technicalSpecs: {
        "材质工艺": "合金车身 + 橡胶轮胎 + 塑料部件",
        "包装规格": "赛车工业风全封闭彩盒 (带吸塑内衬)",
        "授权信息": "Nissan & Top Secret 双重正版授权",
        "模具批次": "2026年Q2全新改良版重配模具",
        "适合年龄": "14岁以上收藏级玩家",
      },
    );
  }
}
