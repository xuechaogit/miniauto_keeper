import 'package:flutter/material.dart';
import 'package:miniauto_keeper/core/theme/app_theme.dart';
import 'package:miniauto_keeper/core/widgets/divider/divider.dart';
import 'package:mix/mix.dart';

import 'card_panel.style.dart';

class CardPanel extends StatelessWidget {
  final String? title;
  final Widget content;
  final Style? cardStyle;
  final bool showDivider;

  const CardPanel({
    super.key,
    this.title,
    required this.content,
    this.cardStyle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Box(
      style: CardPanelStyle.base.merge(cardStyle ?? const Style.empty()),
      child: VBox(
        style: Style($flex.gap(0)),
        children: [
          if (title != null) ...[
            Box(
              style: Style(
                $box.width.infinity(),
                $box.margin.bottom.ref(mxt.space.small),
                $text.textAlign.start(),
              ),
              child: StyledText(title!, style: CardPanelStyle.title),
            ),

            if (showDivider) const AppDivider(),
          ],
          content,
        ],
      ),
    );
  }
}
