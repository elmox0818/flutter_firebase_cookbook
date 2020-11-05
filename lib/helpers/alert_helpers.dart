// lib/helpers/alert_helpers.dart

import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AlertHelpers {
  void showFlash(BuildContext context, String message, MaterialColor color) {
    Flushbar(
      message: message,
      backgroundColor: color,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void showWarningDialog(
      BuildContext context, String title, String message, Function okFunction) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: false,
      animType: AnimType.TOPSLIDE,
      title: title,
      desc: message,
      btnCancelOnPress: () {},
      btnOkOnPress: okFunction,
    )..show();
  }
}
