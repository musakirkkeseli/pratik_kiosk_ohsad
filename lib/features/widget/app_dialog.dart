import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utility/const/constant_color.dart';
import '../utility/const/constant_string.dart';
import '../utility/extension/text_theme_extension.dart';

class AppDialog {
  late BuildContext context;
  AppDialog(this.context);

  Future<dynamic> loadingDialog() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: ConstColor.transparent,
        child: WillPopScope(
          child: Center(
            child: Lottie.asset(ConstantString.healthGif, width: 150),
          ),
          onWillPop: () async => false,
        ),
      ),
    );
  }

  infoShowDialog(
    String title,
    String descript, {
    void Function()? firstOnPressed,
    void Function()? secondOnPressed,
    String? firstActionText,
    String? secondActionText,
  }) {
    return showDialog(
      context: context,
      builder: (context) => defaultAlertDialog(
        title,
        descript,
        firstOnPressed: firstOnPressed,
        secondOnPressed: secondOnPressed,
        firstActionText: firstActionText,
        secondActionText: secondActionText,
      ),
    );
  }

  infoDialog(
    String title,
    String descript, {
    void Function()? firstOnPressed,
    void Function()? secondOnPressed,
    String? firstActionText,
    String? secondActionText,
    void Function(dynamic onValue)? afterFunc,
  }) {
    return Navigator.of(context)
        .push(
          RawDialogRoute(
            pageBuilder: (dialogcontext, animation, secondaryAnimation) =>
                defaultAlertDialog(
                  title,
                  descript,
                  firstOnPressed: firstOnPressed,
                  secondOnPressed: secondOnPressed,
                  firstActionText: firstActionText,
                  secondActionText: secondActionText,
                ),
          ),
        )
        .then(afterFunc ?? (_) {});
  }

  defaultAlertDialog(
    String title,
    String descript, {
    void Function()? firstOnPressed,
    void Function()? secondOnPressed,
    String? firstActionText,
    String? secondActionText,
  }) {
    return AlertDialog(
      backgroundColor: ConstColor.white,
      title: Text(title),
      content: Text(descript),
      actions: [
        secondActionText is String
            ? TextButton(
                onPressed: secondOnPressed is Function()
                    ? secondOnPressed
                    : null,
                child: Text(
                  secondActionText,
                  style: context.dialogContent,
                ),
              )
            : Container(),
        TextButton(
          onPressed: firstOnPressed is Function()
              ? firstOnPressed
              : () {
                  Navigator.pop(context);
                },
          child: Text(
            firstActionText ?? ConstantString().close,
            style: context.dialogContent,
          ),
        ),
      ],
    );
  }
}
