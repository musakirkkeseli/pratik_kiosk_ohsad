import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../core/utility/session_manager.dart';
import '../../../../core/utility/user_login_status_service.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_payment_result_type.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';

class PaymentResultWidget extends StatelessWidget {
  final EnumPaymentResultType paymentResultType;
  final String? totalAmount;
  final String? transactionId;
  final String? doctorName;
  final String? sectionName;

  const PaymentResultWidget({
    super.key,
    required this.paymentResultType,
    required this.totalAmount,
    required this.transactionId,
    required this.doctorName,
    required this.sectionName,
  });

  @override
  Widget build(BuildContext context) {
    // compute dynamic dates/times
    final now = DateTime.now();
    String _turkishMonth(int m) {
      const months = [
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];
      return months[m - 1];
    }

    final todayDate = '${now.day} ${_turkishMonth(now.month)} ${now.year}';
    String _twoDigits(int v) => v.toString().padLeft(2, '0');
    final nowTime = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}';
    final plus20 = now.add(const Duration(minutes: 20));
    final plus20Time =
        '${_twoDigits(plus20.hour)}:${_twoDigits(plus20.minute)}';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstColor.grey300,
                        foregroundColor: ConstColor.grey700,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: ConstColor.grey700,
                      ),
                      label: Text(
                        ConstantString().homePageTitle,

                        style: context.cardTitle.copyWith(
                          fontSize: 14,
                          color: ConstColor.grey700,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConstColor.transparent,
                          foregroundColor: context.primaryColor,
                          elevation: 0,
                          side: BorderSide(
                            color: context.primaryColor,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          UserLoginStatusService().logout(
                            reason: SessionEndReason.completed,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Iconify(
                              MaterialSymbols.exit_to_app,
                              color: context.primaryColor,
                            ),
                            Text(
                              ConstantString().logout,
                              style: context.buttonText.copyWith(
                                color: context.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.check_circle,
                color: paymentResultType.color,
                size: 100,
              ),
              Text(paymentResultType.title, style: context.successText),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(paymentResultType.description, style: context.bodyPrimary),
              Text(paymentResultType.message, style: context.bodyPrimary),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: ConstColor.textfieldColor),
                  color: ConstColor.infoCardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _PaymentInfoRow(
                      label: ConstantString().amountPaid,
                      value: "${totalAmount ?? '0'} ₺",
                      valueColor: context.primaryColor,
                      valueSize: 32,
                      valueBold: true,
                    ),
                    Divider(color: ConstColor.textfieldColor),
                    _PaymentInfoRow(
                      label: ConstantString().paymentMethod,
                      value: ConstantString().creditCard,
                    ),
                    Divider(color: ConstColor.textfieldColor),
                    _PaymentInfoRow(
                      label: ConstantString().transactionDate,
                      value: "$todayDate $nowTime",
                    ),
                    Divider(color: ConstColor.textfieldColor),
                    _PaymentInfoRow(
                      label: ConstantString().transactionNumber,
                      value: transactionId ?? "",
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        ConstantString().examinationDetails,
                        style: context.sectionTitle.copyWith(
                          fontSize: 24,
                          color: ConstColor.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ConstantString().section,
                                style: context.caption.copyWith(
                                  color: ConstColor.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                sectionName ?? "",
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: ConstColor.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                ConstantString().date,
                                style: context.caption.copyWith(
                                  color: ConstColor.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                todayDate,
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: ConstColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ConstantString().doctor,
                                style: context.caption.copyWith(
                                  color: ConstColor.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                doctorName ?? "",
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: ConstColor.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                ConstantString().hour,
                                style: context.caption.copyWith(
                                  color: ConstColor.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                plus20Time,
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: ConstColor.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final double? valueSize;
  final bool valueBold;

  const _PaymentInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueSize,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.bodySecondary),
          Text(
            value,
            style: context.bodyPrimary.copyWith(
              fontSize: valueSize ?? 16,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
