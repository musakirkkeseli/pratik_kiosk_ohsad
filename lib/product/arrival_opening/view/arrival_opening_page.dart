import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/const/constant_color.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';
import 'package:intl/intl.dart';

class ArrivalOpeningPage extends StatefulWidget {
  const ArrivalOpeningPage({super.key});

  @override
  State<ArrivalOpeningPage> createState() => _ArrivalOpeningPageState();
}

class _ArrivalOpeningPageState extends State<ArrivalOpeningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.grey100,
      appBar: AppBar(
        title: Text(ConstantString().arrivalOpening),
        backgroundColor: ConstColor.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ArrivalOpeningCard(
              date: DateTime.now(),
              time: "14:30",
              department: "Kardiyoloji",
              doctor: "Dr. Mehmet Yılmaz",
              fees: [
                {"name": "Muayene Ücreti", "amount": "150 TL"},
                {"name": "Konsültasyon", "amount": "200 TL"},
              ],
              onCancel: () {
                _showCancelConfirmation(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Geliş İptali", style: context.sectionTitle),
          content: Text(
            "Randevunuzun gelişini iptal etmek istediğinizden emin misiniz?",
            style: context.bodyPrimary,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Vazgeç", style: context.bodySecondary),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // İptal işlemini gerçekleştir
              },
              style: ElevatedButton.styleFrom(backgroundColor: ConstColor.red),
              child: Text("İptal Et", style: context.whiteButtonText),
            ),
          ],
        );
      },
    );
  }
}

class ArrivalOpeningCard extends StatelessWidget {
  final DateTime date;
  final String time;
  final String department;
  final String doctor;
  final List<Map<String, String>> fees;
  final VoidCallback onCancel;

  const ArrivalOpeningCard({
    super.key,
    required this.date,
    required this.time,
    required this.department,
    required this.doctor,
    required this.fees,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMMM yyyy', 'tr_TR');
    final formattedDate = dateFormatter.format(date);

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
            // Başlık
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

            // Tarih/Saat ve Bölüm/Doktor yan yana
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Tarih ve Saat (Alt alta)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.calendar_today_rounded,
                          label: "Tarih",
                          value: formattedDate,
                        ),
                        const SizedBox(height: 10),
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.access_time_rounded,
                          label: "Saat",
                          value: time,
                        ),
                      ],
                    ),
                  ),

                  // Ayırıcı çizgi
                  Container(
                    width: 1,
                    height: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    color: context.primaryColor.withOpacity(0.2),
                  ),

                  // Bölüm ve Doktor (Alt alta)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.local_hospital_rounded,
                          label: "Bölüm",
                          value: department,
                        ),
                        const SizedBox(height: 10),
                        _buildDateTimeInfo(
                          context,
                          icon: Icons.person_rounded,
                          label: "Doktor",
                          value: doctor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Ücretler Bölümü
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
                  ...fees.map(
                    (fee) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fee["name"]!,
                            style: context.bodySecondary.copyWith(fontSize: 14),
                          ),
                          Text(
                            fee["amount"]!,
                            style: context.primaryText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
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
                        _calculateTotal(),
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

            // İptal Butonu
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

  String _calculateTotal() {
    int totalAmount = 0;

    for (var feeItem in fees) {
      final amountText = feeItem["amount"]!;
      final cleanAmount = amountText.replaceAll(" TL", "").replaceAll(",", "");
      final amountValue = int.tryParse(cleanAmount) ?? 0;

      totalAmount += amountValue;
    }

    return "$totalAmount TL";
  }
}
