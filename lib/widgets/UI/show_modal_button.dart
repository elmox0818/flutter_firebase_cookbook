// lib/widgets/UI/show_modal_button.dart

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ShowModalButton extends StatelessWidget {
  ShowModalButton(this._icon, this._showWidget);
  final Icon _icon;
  final Widget _showWidget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _icon,
      onPressed: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context, scrollController) => _showWidget,
        );
      },
    );
  }
}
