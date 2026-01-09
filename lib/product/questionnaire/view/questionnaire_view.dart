import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/const/constant_color.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../features/utility/const/constant_string.dart';

class QuestionnaireView extends StatefulWidget {
  const QuestionnaireView({super.key});

  @override
  State<QuestionnaireView> createState() => _QuestionnaireViewState();
}

class _QuestionnaireViewState extends State<QuestionnaireView> {
  final String _formUrl = ConstantString.form;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ConstantString().scanQrToFillSurvey,
            style: context.questionnaireText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ConstColor.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: _formUrl,
              version: QrVersions.auto,
              size: 130.0,
              backgroundColor: ConstColor.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),
        ],
      ),
    );
  }
}
