import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';

class PatientTransactionManagmentButton extends StatefulWidget {
  const PatientTransactionManagmentButton({super.key});

  @override
  State<PatientTransactionManagmentButton> createState() =>
      _PatientTransactionManagmentButtonState();
}

class _PatientTransactionManagmentButtonState
    extends State<PatientTransactionManagmentButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      height: MediaQuery.of(context).size.height * 0.07,
      child: ElevatedButton(
        onPressed: () {
          NavigationService.ns.routeTo("PatientTransactionManagementView");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Iconify(Mdi.account_check, color: ConstColor.white, size: 35),
                  const SizedBox(width: 16),
                  Text(
                    ConstantString().arrivalOpening,
                    style: context.buttonText.copyWith(
                      color: ConstColor.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: ConstColor.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
