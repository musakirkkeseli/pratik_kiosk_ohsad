import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

import '../../../patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/widget/item_button.dart';
import '../../../make_appointment/view/appointment_slot_view.dart';
import '../../model/doctor_model.dart';

class DoctorListTileWidget extends StatelessWidget {
  final List<DoctorItems> doctorItemList;
  final bool isAppointment;
  const DoctorListTileWidget({
    super.key,
    required this.doctorItemList,
    required this.isAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: doctorItemList.length,
      itemBuilder: (context, index) {
        DoctorItems doctor = doctorItemList[index];
        return ItemButton(
          title: "${doctor.doctorTitle} ${doctor.doctorName}",
          onTap: () {
            if (isAppointment) {
              MyLog.debug(
                "Doctor Selected for Appointment: ${doctor.doctorName}",
              );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AppointmentSlotView(
                    doctorId: int.tryParse(doctor.doctorId ?? '0') ?? 0,
                    departmentId: int.tryParse(doctor.departmentId ?? '0') ?? 0,
                    doctorName: doctor.doctorName ?? '',
                    departmentName: doctor.departmentName ?? '',
                  ),
                ),
              );
            } else {
              if (doctor.doctorTitle == "Prof. Dr.") {
                SnackbarService().showSnackBar(ConstantString().profDrRecords);
              } else {
                context.read<PatientRegistrationProceduresCubit>().selectDoctor(
                  doctor,
                );
              }
            }
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
