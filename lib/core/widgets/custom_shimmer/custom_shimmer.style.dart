import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/app_theme.dart';

class CustomShimmerStyles {
  /// 骨架屏骨骼块默认样式 (必须赋予不透明实体色，让 Shimmer 能够抓取像素点进行染色)
  static Style get defaultBlock =>
      Style($box.color.ref(mxt.color.shimmerBase), $box.borderRadius(4));
}
