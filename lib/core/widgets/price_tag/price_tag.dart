import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'price_tag.style.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final double originalPrice;

  const PriceTag({super.key, required this.price, required this.originalPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        StyledText('\$ ', style: PriceTagStyle.currency),
        StyledText('$price', style: PriceTagStyle.price),
        if (originalPrice > price) ...[
          SizedBox(width: 8),
          StyledText('¥$originalPrice', style: PriceTagStyle.originalPrice),
        ],
      ],
    );
  }
}
