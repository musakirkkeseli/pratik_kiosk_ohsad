import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/navigation_service.dart';
import 'package:provider/provider.dart';

import '../../../patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/widget/item_button.dart';
import '../../model/section_model.dart';

class SectionSearchListViewWidget extends StatelessWidget {
  final List<SectionItems> sectionItemList;
  final bool isAppointment;
  const SectionSearchListViewWidget({
    super.key,
    required this.sectionItemList,
    required this.isAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 20),
      itemCount: sectionItemList.length,
      itemBuilder: (context, index) {
        SectionItems section = sectionItemList[index];
        return ItemButton(
          title: section.sectionName ?? "",
          onTap: () {
            if (isAppointment) {
              NavigationService.ns.routeTo(
                "DoctorSearchView",
                arguments: {"sectionId": section.sectionId ?? 0},
              );
            } else {
              context.read<PatientRegistrationProceduresCubit>().selectSection(
                section,
              );
            }
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
