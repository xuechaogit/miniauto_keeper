class ProductDetailModel {
  final int id;
  final String title;
  final String? year;
  final double price;
  final double originalPrice;
  final String thumb;
  final List<String> pics;
  final String code;
  final String dash;
  final int moq;
  final int max;
  final int ordernums;
  final double discount;
  final String? warehouse;
  final String? shipAt;
  final String? shipAtRaw;
  final String? openDate;
  final String? createdAt;
  final String? soldOutAt;
  final String? date;
  final String? itemType;
  final String content;
  final String? erpRating;
  final String? memberRating;
  final double? pointsPrice;
  final int? priceType;
  final int? stockItemId;
  final int? itemId;
  final int? pid;
  final int? assetId;
  final String? itemDisclaimer;
  final String? topLevelCategory;
  final String? level2Category;
  final String? series;
  final int? casepack;
  final String? country;
  final String? countryCode;
  final bool isFavourite;
  final bool showSubscribeBtn;
  final bool isCountdown;
  final bool hasCart;
  final int? editionCount;
  final List<String> bundleTags;
  final String? auctionStatus;

  ProductDetailModel({
    required this.id,
    required this.title,
    this.year,
    required this.price,
    required this.originalPrice,
    required this.thumb,
    required this.pics,
    required this.code,
    required this.dash,
    required this.moq,
    required this.max,
    required this.ordernums,
    required this.discount,
    this.warehouse,
    this.shipAt,
    this.shipAtRaw,
    this.openDate,
    this.createdAt,
    this.soldOutAt,
    this.date,
    this.itemType,
    required this.content,
    this.erpRating,
    this.memberRating,
    this.pointsPrice,
    this.priceType,
    this.stockItemId,
    this.itemId,
    this.pid,
    this.assetId,
    this.itemDisclaimer,
    this.topLevelCategory,
    this.level2Category,
    this.series,
    this.casepack,
    this.country,
    this.countryCode,
    required this.isFavourite,
    required this.showSubscribeBtn,
    required this.isCountdown,
    required this.hasCart,
    this.editionCount,
    required this.bundleTags,
    this.auctionStatus,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] ?? '',
      year: json['year']?.toString(),
      price: double.tryParse('${json['price'] ?? ''}') ?? 0.0,
      originalPrice:
          double.tryParse('${json['original_price'] ?? ''}') ?? 0.0,
      thumb: json['thumb'] ?? '',
      pics: (json['pics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      code: json['code'] ?? '',
      dash: json['dash'] ?? '',
      moq: (json['moq'] as num?)?.toInt() ?? 0,
      max: (json['max'] as num?)?.toInt() ?? 0,
      ordernums: (json['ordernums'] as num?)?.toInt() ?? 0,
      discount: double.tryParse('${json['discount'] ?? ''}') ?? 1.0,
      warehouse: json['warehouse']?.toString(),
      shipAt: json['ship_at']?.toString(),
      shipAtRaw: json['ship_at_raw']?.toString(),
      openDate: json['openDate']?.toString(),
      createdAt: json['created_at']?.toString(),
      soldOutAt: json['sold_out_at']?.toString(),
      date: json['date']?.toString(),
      itemType: json['itemType']?.toString(),
      content: json['content'] ?? '',
      erpRating: json['erp_rating']?.toString(),
      memberRating: json['member_rating']?.toString(),
      pointsPrice: json['points_price'] != null
          ? double.tryParse('${json['points_price']}')
          : null,
      priceType: (json['price_type'] as num?)?.toInt(),
      stockItemId: (json['stock_item_id'] as num?)?.toInt(),
      itemId: (json['itemId'] as num?)?.toInt(),
      pid: (json['pid'] as num?)?.toInt(),
      assetId: (json['asset_id'] as num?)?.toInt(),
      itemDisclaimer: json['itemDisclaimer']?.toString(),
      topLevelCategory: json['top_level_category']?.toString(),
      level2Category: json['level2_category']?.toString(),
      series: json['series']?.toString(),
      casepack: (json['casepack'] as num?)?.toInt(),
      country: json['country']?.toString(),
      countryCode: json['country_code']?.toString(),
      isFavourite: json['isFavourite'] == true || json['isFavourite'] == 1,
      showSubscribeBtn:
          json['showSubscribeBtn'] == true || json['showSubscribeBtn'] == 1,
      isCountdown: json['is_countdown'] == 1 || json['is_countdown'] == true,
      hasCart: json['hasCart'] == 1 || json['hasCart'] == true,
      editionCount: (json['edition_count'] as num?)?.toInt(),
      bundleTags: (json['bundle_tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      auctionStatus: json['auctionStatus']?.toString(),
    );
  }
}
