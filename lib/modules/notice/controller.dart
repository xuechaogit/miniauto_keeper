import 'package:get/get.dart';

class NoticeModel {
  final String id;
  final String title;
  final String content;
  final String date;
  final bool isImportant;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.isImportant = false,
  });
}

class NoticeController extends GetxController {
  final notices = <NoticeModel>[].obs;
  final isLoading = true.obs; // 首次进入或下拉刷新的全局加载状态
  final isLoadingMore = false.obs; // 底部加载更多的轻量状态
  final hasMore = true.obs; // 是否还有更多数据

  int _page = 1; // 当前页码
  final int _pageSize = 4; // 每页条数

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
  }

  // 模拟 API 数据库（准备了多条数据用来测试分页）
  final List<NoticeModel> _mockDatabase = [
    NoticeModel(
      id: '1',
      title: '【系统维护】版本底层架构升级公告',
      content:
          '为了提供更极致的响应速度与系统稳定性，我们将于本周五凌晨 02:00 - 04:00 进行服务端集群升级。届时部分同步数据可能会有短暂延迟，感谢您的理解与支持。',
      date: '2026-05-20',
      isImportant: true,
    ),
    NoticeModel(
      id: '2',
      title: '【新功能上线】车辆价值趋势图表已支持多维对比',
      content:
          '新版本中，Garage 模块的 fl_chart 价值成长曲线已全量升级！现在您可以勾选多台珍藏模型，在同一画布下直观对比它们的价格走势与历史涨幅。快去体验吧！',
      date: '2026-05-18',
    ),
    NoticeModel(
      id: '3',
      title: '【社区规范】关于规范模型交易与模型成色描述的通知',
      content:
          '近期发现部分用户在车库展示区交流时出现成色描述不符的情况。为维护硬核、纯粹的玩车生态，请务必严格按照官方成色分级指引进行标注。',
      date: '2026-05-15',
    ),
    NoticeModel(
      id: '4',
      title: '【品牌入驻】Mini GT x Kaido House 独家新品首发预告',
      content:
          '绝密企划！下周二将开启全新 1:64 赛车合金模型预售，包含限定版宽体涂装，专属 VIP 分配额度将优先面向高阶车库车长开放，敬请锁定。',
      date: '2026-05-12',
      isImportant: true,
    ),
    NoticeModel(
      id: '5',
      title: '【日常优化】ERP 调拨系统吞吐量优化完毕',
      content:
          '针对批发商端大批量拉取 ERP 订单时的性能瓶颈，技术团队已完成了对核心二叉搜索树及索引过滤器的重构，目前高并发结算速度提升了近 45%。',
      date: '2026-05-10',
    ),
    NoticeModel(
      id: '6',
      title: '【物流通知】海外仓海运专线运费下调通知',
      content:
          '得益于与集装箱航运巨头的长期战略协议签署，本月起欧美核心港口清关仓配成本降低，大批发商用户的物流燃油附加费将按比例下调 4.5 个百分点。',
      date: '2026-05-08',
    ),
    NoticeModel(
      id: '7',
      title: '【重要提醒】关于防止账号共享与数据泄露的安全提示',
      content:
          '近期监测到少数账号存在跨地域异常登录。请各位批发商保护好个人的 SSH 凭证及 API 密钥，切勿将主账号外借，系统将对违规多开行为实行风控锁定。',
      date: '2026-05-05',
    ),
  ];

  // 刷新或初次加载
  Future<void> fetchNotices() async {
    _page = 1;
    hasMore.value = true;
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1000)); // 模拟网络延迟

    // 模拟截取第一页数据
    final firstPageData = _mockDatabase.take(_pageSize).toList();
    notices.assignAll(firstPageData);

    isLoading.value = false;
  }

  // 加载更多
  Future<void> fetchMoreNotices() async {
    // 防抖：如果正在加载或者已经没有更多了，直接拦截
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 2000)); // 模拟微小延迟

    final int startIndex = _page * _pageSize;

    if (startIndex >= _mockDatabase.length) {
      hasMore.value = false;
    } else {
      // 计算下一页的截取范围
      final nextPageData = _mockDatabase
          .skip(startIndex)
          .take(_pageSize)
          .toList();
      notices.addAll(nextPageData);
      _page++;

      // 判断加完这页后是否到头了
      if (notices.length >= _mockDatabase.length) {
        hasMore.value = false;
      }
    }

    isLoadingMore.value = false;
  }

  // 当前详情公告
  final currentNotice = Rxn<NoticeModel>();

  void viewDetails(NoticeModel notice) {
    currentNotice.value = notice;
    print('当前详情公告：${notice.title}');
    Get.toNamed('/notice/detail', arguments: {'id': notice.id});
  }
}
