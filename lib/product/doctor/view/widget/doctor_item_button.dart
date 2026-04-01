import 'package:flutter/material.dart';

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
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Ink(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 2,
            color: context.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              Image.network(
                doctorImageUrl,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.primaryColor.withOpacity(0.1),
                    ),
                    child: Icon(Icons.person, color: context.primaryColor),
                  );
                },
              ),
              Expanded(child: Text(title, style: context.cardTitle)),
              Icon(Icons.arrow_forward_ios, color: context.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
