// lib/helpers/alert_helpers.dart

import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

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
}
