import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/widgets/load_more_footer/load_more_footer.style.dart';
import 'package:mix/mix.dart';

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
    return Box(
      style: LoadMoreFooterStyle.container,
      child: switch (status) {
        LoadMoreStatus.loading => _buildLoading(),
        LoadMoreStatus.error => _buildError(),
        LoadMoreStatus.noMore => _buildNoMore(),
      },
    );
  }

  Widget _buildLoading() {
    return Opacity(
      opacity: 0.45,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: LoadMoreFooterStyle.spinnerSize,
            height: LoadMoreFooterStyle.spinnerSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: LoadMoreFooterStyle.spinnerGap),
          StyledText('正在加载更多...', style: LoadMoreFooterStyle.loadingText),
        ],
      ),
    );
  }

  Widget _buildError() {
    return GestureDetector(
      onTap: onRetry,
      child: Opacity(
        opacity: 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StyledIcon(Icons.refresh, style: LoadMoreFooterStyle.errorIcon),
            const SizedBox(width: 6),
            StyledText('加载失败，点击重试', style: LoadMoreFooterStyle.errorText),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMore() {
    return Opacity(
      opacity: 0.25,
      child: StyledText('—— 已经到底了 ——', style: LoadMoreFooterStyle.noMoreText),
    );
  }
}
