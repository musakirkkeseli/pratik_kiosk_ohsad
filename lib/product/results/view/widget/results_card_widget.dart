import 'package:flutter/material.dart';

import '../../../../core/widget/custom_image.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/color_extension.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';

class ResultsCard extends StatelessWidget {
  final String reportName;
  final String reportDate;
  final String reportStatus;
  final String doctorName;
  final String? doctorId;
  final String departmentName;
  final VoidCallback? onTap;

  const ResultsCard({
    super.key,
    required this.reportName,
    required this.reportDate,
    required this.reportStatus,
    required this.doctorName,
    this.doctorId,
    required this.departmentName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: ConstColor.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(color: context.primaryColor, width: 8),
            ),
            boxShadow: [
              BoxShadow(
                color: ConstColor.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        reportName,
                        style: context.sectionTitle.copyWith(fontSize: 24),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: context.primaryColor.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            context,
                            label: ConstantString().date,
                            value: reportDate,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            context,
                            label: ConstantString().policlinic,
                            value: departmentName,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (doctorId != null && doctorId!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: context.primaryColor
                                              .withValues(alpha: 0.1),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: context.primaryColor
                                                .withValues(alpha: 0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CustomImage.image(
                                          "https://kiosk.prtk.gen.tr/assets/images/doctor/$doctorId.png",
                                          CustomImageType.doctor,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Doktor',
                                            style: context.bodySecondary
                                                .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            doctorName,
                                            style: context.primaryText.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            _buildInfoRow(
                              context,
                              label: ConstantString().doctor,
                              value: doctorName,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(reportStatus).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(
                        reportStatus,
                      ).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(reportStatus),
                        color: _getStatusColor(reportStatus),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        reportStatus,
                        style: context.primaryText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(reportStatus),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodySecondary.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.primaryText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status.toLowerCase().contains('Hazır') ||
        status.toLowerCase().contains('Tamamlandı')) {
      return ConstColor.green;
    } else if (status.toLowerCase().contains('beklenen')) {
      return ConstColor.orange;
    } else if (status.toLowerCase().contains('iptal')) {
      return ConstColor.red;
    }
    return ConstColor.blue;
  }

  IconData _getStatusIcon(String status) {
    if (status.toLowerCase().contains('hazır') ||
        status.toLowerCase().contains('tamamlandı')) {
      return Icons.check_circle;
    } else if (status.toLowerCase().contains('beklenen')) {
      return Icons.schedule;
    } else if (status.toLowerCase().contains('iptal')) {
      return Icons.cancel;
    }
    return Icons.info;
  }
}
