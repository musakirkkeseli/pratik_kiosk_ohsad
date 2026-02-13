import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';
import 'package:signature/signature.dart';

import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';

Future<Uint8List?> showSignaturePopup(BuildContext context) async {
  final SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: ConstColor.black,
    exportBackgroundColor: ConstColor.white,
  );

  return await showDialog<Uint8List?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(
        ConstantString().pleaseProvideSignature,
        style: context.subTitle,
      ),
      content: SizedBox(
        width: 600,
        height: 300,
        child: Container(
          decoration: BoxDecoration(
            color: ConstColor.grey[200]!,
            border: Border.all(color: ConstColor.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: controller,
            backgroundColor: ConstColor.grey[200]!,
          ),
        ),
      ),
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            controller.clear();
          },
          icon: const Icon(Icons.clear, color: ConstColor.red),
          label: Text(ConstantString().clear, style: context.clearText),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: const BorderSide(color: ConstColor.red, width: 2),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            if (controller.isNotEmpty) {
              final signature = await controller.toPngBytes();
              Navigator.of(context).pop(signature);
            } else {
              SnackbarService().showSnackBar(ConstantString().pleaseSignFirst);
            }
          },
          icon: const Icon(Icons.check, color: ConstColor.white),
          label: Text(ConstantString().save, style: context.saveButtonText),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            backgroundColor: ConstColor.green,
          ),
        ),
      ],
    ),
  );
}
