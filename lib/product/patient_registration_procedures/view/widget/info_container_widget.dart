import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/color_extension.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../model/patient_registration_procedures_request_model.dart';

class InfoContainerWidget extends StatefulWidget {
  final PatientRegistrationProceduresModel model;

  const InfoContainerWidget({super.key, required this.model});

  @override
  State<InfoContainerWidget> createState() => _State();
}

class _State extends State<InfoContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      decoration: BoxDecoration(
        color: ConstColor.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: context.primaryColor, width: 8)),
        boxShadow: [
          BoxShadow(
            color: ConstColor.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            infoWidget(
              ConstantString().section,
              widget.model.branchName,
              context,
            ),
            _DashedDivider(),
            infoWidget(
              ConstantString().doctor,
              widget.model.doctorName,
              context,
            ),
            _DashedDivider(),
            infoWidget(
              ConstantString().insurance,
              widget.model.assocationName,
              context,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomPaint(
        size: Size(double.infinity, 1),
        painter: _DashedLinePainter(color: ConstColor.grey[400]!),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

infoWidget(String title, String? text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            Text("$title: ", style: context.cardTitle),
            Expanded(
              child: text != null && text.isNotEmpty
                  ? Text(
                      text,
                      textAlign: TextAlign.left,
                      style: context.bodyPrimary,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  : Text("-", style: context.bodySecondary),
            ),
          ],
        ),
      ],
    ),
  );
}
