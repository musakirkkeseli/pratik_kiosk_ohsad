import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/extension/color_extension.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../model/patient_transaction_model.dart';

class PatientTransactionCard extends StatelessWidget {
  final PatientTransactionModel model;
  final VoidCallback onCancel;

  const PatientTransactionCard({
    super.key,
    required this.model,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      decoration: BoxDecoration(
        color: ConstColor.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(top: BorderSide(color: context.primaryColor, width: 6)),
        boxShadow: [
          BoxShadow(
            color: ConstColor.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event_available_rounded,
                    color: context.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Randevu Geliş Bilgileri",
                    style: context.sectionTitle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.calendar_today_rounded,
                          label: "Tarih",
                          value: model.date ?? "",
                        ),
                        const SizedBox(height: 10),
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.access_time_rounded,
                          label: "Saat",
                          value: model.time ?? "",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    color: context.primaryColor.withOpacity(0.2),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.local_hospital_rounded,
                          label: "Bölüm",
                          value: model.branchName ?? "",
                        ),
                        const SizedBox(height: 10),
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.person_rounded,
                          label: "Doktor",
                          value: model.doctorName ?? "",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ConstColor.grey200.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ConstColor.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        color: context.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Tahsil Edilen Ücretler",
                        style: context.bodyPrimary.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...(model.revenues ?? []).map(
                    (fee) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fee.processName ?? "",
                            style: context.bodySecondary.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Toplam",
                        style: context.bodyPrimary.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${model.totalAmount ?? 0} TL",
                        style: context.primaryText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ConstColor.red,
                  side: const BorderSide(color: ConstColor.red, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cancel_outlined,
                      color: ConstColor.red,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Geliş İptal Et",
                      style: context.errorText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: context.primaryColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.bodySecondary.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: context.primaryText.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
