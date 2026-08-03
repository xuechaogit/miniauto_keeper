import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/widgets/load_more_footer/load_more_footer.style.dart';

enum LoadMoreStatus { loading, error, noMore }

class LoadMoreFooter extends StatelessWidget {
  final LoadMoreStatus status;
  final VoidCallback? onRetry;

  const LoadMoreFooter({
    super.key,
    required this.status,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: LoadMoreFooterStyle.containerHeight,
      child: Center(
        child: switch (status) {
          LoadMoreStatus.loading => _buildLoading(),
          LoadMoreStatus.error => _buildError(),
          LoadMoreStatus.noMore => _buildNoMore(),
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: LoadMoreFooterStyle.spinnerSize,
          height: LoadMoreFooterStyle.spinnerSize,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: LoadMoreFooterStyle.spinnerGap),
        Text('正在加载更多...', style: LoadMoreFooterStyle.textStyle),
      ],
    );
  }

  Widget _buildError() {
    return GestureDetector(
      onTap: onRetry,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.refresh, size: 16, color: Color(0xFF16181D)),
          const SizedBox(width: 6),
          Text('加载失败，点击重试', style: LoadMoreFooterStyle.errorTextStyle),
        ],
      ),
    );
  }

  Widget _buildNoMore() {
    return Text('—— 已经到底了 ——', style: LoadMoreFooterStyle.noMoreTextStyle);
  }
}
