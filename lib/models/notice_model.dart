class NoticeModel {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String categoryName;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.categoryName,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }
}

class NoticeListData {
  final List<NoticeModel> list;

  NoticeListData({required this.list});

  factory NoticeListData.fromJson(Map<String, dynamic> json) {
    return NoticeListData(
      list: (json['list'] as List<dynamic>?)
              ?.map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
