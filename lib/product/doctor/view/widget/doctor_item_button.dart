import 'package:flutter/material.dart';

import '../../../../core/widget/custom_image.dart';
import '../../../../features/utility/extension/color_extension.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';

class DoctorItemButton extends StatelessWidget {
  final String title;
  final String doctorImageUrl;
  final VoidCallback onTap;

  const DoctorItemButton({
    super.key,
    required this.title,
    required this.doctorImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Ink(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            width: 2,
            color: context.primaryColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                  child: CustomImage.image(
                    doctorImageUrl,
                    CustomImageType.doctor,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: context.cardTitle)),
              Icon(Icons.arrow_forward_ios, color: context.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
