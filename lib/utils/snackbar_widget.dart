import 'package:flutter/material.dart';
import 'package:flutter_cvmaker/config.dart';

class SnackbarWidget {
  static SnackBar show(BuildContext context,
      {required String text, int milliseconds = 1500}) {
    final snackBar = SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: defaultSideBarColor,
        padding: const EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: milliseconds));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return snackBar;
  }
}
