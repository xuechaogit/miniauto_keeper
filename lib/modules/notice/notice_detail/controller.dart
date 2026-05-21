import 'package:get/get.dart';
import '../controller.dart';

class NoticeDetailController extends GetxController {
  final isLoading = true.obs;
  final notice = Rxn<NoticeModel>();

  @override
  void onInit() {
    super.onInit();
    // 从路由中动态获取传递过来的公告 ID
    // 比如：Get.toNamed('/notice/detail', arguments: {'id': '4'});
    final String? noticeId = Get.arguments?['id'];

    if (noticeId != null) {
      fetchNoticeDetail(noticeId);
    } else {
      isLoading.value = false;
    }
  }

  /// 模拟从后端数据库拉取特定 ID 的高精度详情数据
  Future<void> fetchNoticeDetail(String id) async {
    isLoading.value = true;

    // 模拟网络硬件吞吐延迟 (700毫秒)，配合工业风的异步氛围
    await Future.delayed(const Duration(milliseconds: 700));

    // 严谨的模拟详情数据库
    final List<NoticeModel> _detailDatabase = [
      NoticeModel(
        id: '1',
        title: '【系统维护】版本底层架构升级公告',
        content:
            '为了提供更极致的响应速度与系统稳定性，我们将于本周五凌晨 02:00 - 04:00 进行服务端集群升级。\n\n'
            '本次重构涉及对底层二叉搜索树索引的进一步拓扑调整，优化高并发状态下的缓存溢出问题。'
            '届时部分同步数据可能会有短暂延迟，建议大批发商用户提前安排调拨订单避开该时段，感谢您的理解与支持。',
        date: '2026-05-20',
        isImportant: true,
      ),
      NoticeModel(
        id: '2',
        title: '【新功能上线】车辆价值趋势图表已支持多维对比',
        content:
            '新版本中，MiniAuto Keeper 的 Garage 模块已全量升级！\n\n'
            '基于 fl_chart 封装的价值成长曲线现在已支持【多维对比模式】。'
            '您可以勾选多台珍藏模型（例如 Mini GT 与 Inno64 的限定同款车车型），在同一画布下直观对比它们的价格走势、绝版溢价率与历史涨幅。\n\n'
            '操作指引：进入我的车库 -> 点击右上角对比图标 -> 勾选车辆 -> 生成图表。',
        date: '2026-05-18',
      ),
      NoticeModel(
        id: '4',
        title: '【品牌入驻】Mini GT x Kaido House 独家新品首发预告',
        content:
            '<p>绝密企划，硬核袭来！</p>'
            '<p>下周二将正式开启全新 <strong>1:64 赛车合金模型</strong> 预售，包含极其罕见的限定版赛道宽体涂装。</p>'
            '<p>由于本次属于珍藏级限量发售，专属 <code>VIP 分配额度</code> 将优先面向高阶车库车长开放。'
            '详情请参考 <a href="https://app.macnn.store">积分商城分配细则</a>。</p>',
        date: '2026-05-12',
        isImportant: true,
      ),
    ];

    // 查找匹配的公告实体
    notice.value = _detailDatabase.firstWhere(
      (element) => element.id == id,
      orElse: () => NoticeModel(
        id: id,
        title: 'NOT FOUND',
        content:
            'The requested system notice code [ID: $id] does not exist or has been archived.',
        date: '0000-00-00',
      ),
    );

    isLoading.value = false;
  }
}
