import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:kiosk/features/widget/custom_button.dart';

import '../../../patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/model/patient_price_detail_model.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';

class PriceSuccessWidget extends StatelessWidget {
  final List<PaymentContent> paymentContentList;
  final PatientContent? patientContent;
  const PriceSuccessWidget({
    super.key,
    required this.paymentContentList,
    required this.patientContent,
  });

  @override
  Widget build(BuildContext context) {
    if (patientContent is PatientContent) {
      return Center(
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: CustomButton(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.06,
                  label: ConstantString().makeSecurePayment,
                  onPressed: () {
                    context
                        .read<PatientRegistrationProceduresCubit>()
                        .paymentAction();
                  },
                ),
              ),
            ),
            Divider(color: ConstColor.textfieldColor),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  MaterialSymbols.summarize_rounded,
                  color: context.primaryColor,
                  size: 35,
                ),
                Text(
                  ConstantString().summaryAndInvoice,
                  style: context.pageTitle.copyWith(fontSize: 35),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: ConstColor.textfieldColor,
                  width: 1.0,
                ),
              ),
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: ConstColor.textfieldColor,
                    width: 1.0,
                  ),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: ConstColor.grey100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          ConstantString().description,
                          style: context.cardTitle.copyWith(fontSize: 25),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          ConstantString().amount,
                          style: context.cardTitle.copyWith(fontSize: 25),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  ...paymentContentList.map((paymentContent) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            paymentContent.paymentName ?? "",
                            textAlign: TextAlign.left,
                            style: context.bodyPrimary.copyWith(fontSize: 20),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "${paymentContent.price} ₺",
                            textAlign: TextAlign.right,
                            style: context.cardTitle.copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.primaryColor,
                    context.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: ConstColor.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: ConstColor.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        ConstantString().totalAmount,
                        style: context.priceTitle.copyWith(
                          color: ConstColor.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: ConstColor.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: ConstColor.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${patientContent!.totalPrice} ₺ - ${ConstantString().vatIncluded}",
                          style: context.priceTitle.copyWith(
                            color: context.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // PriceInfoCardWidget(),
          ],
        ),
      );
    }
    return Text(ConstantString().errorOccurred);
  }
}
