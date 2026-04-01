import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/const/constant_color.dart';
import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/product/appointments/services/appointment_services.dart';
import 'package:kiosk/product/appointments/view/widget/appointment_card.dart';

import '../../../core/utility/logger_service.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/navigation_service.dart';
import '../../../features/widget/app_dialog.dart';
import '../../patient_registration_procedures/model/patient_registration_procedures_request_model.dart';
import '../cubit/appointment_cubit.dart';
import '../model/appointments_model.dart';
import 'widget/not_found_appointment.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  final ScrollController _scrollController = ScrollController();
  final MyLog _log = MyLog("AppointmentsView");

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCancelConfirmation(
    BuildContext context,
    String appointmentID,
    String guid,
  ) {
    _log.d("Cancel confirmation - AppointmentID: $appointmentID, GUID: $guid");

    AppDialog(context).infoDialog(
      "Randevu İptali",
      "Bu randevuyu iptal etmek istediğinizden emin misiniz?",
      firstActionText: "Vazgeç",
      firstOnPressed: () {
        Navigator.pop(context);
      },
      secondActionText: "İptal Et",
      secondOnPressed: () {
        Navigator.pop(context);
        _log.d(
          "Calling cancelAppointment with ID: $appointmentID, GUID: $guid",
        );
        context.read<AppointmentCubit>().cancelAppointment(appointmentID, guid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentCubit(service: AppointmentServices(UserHttpService()))
            ..fetchAppointments(),
      child: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          return _body(context, state);
        },
      ),
    );
  }

  _body(BuildContext context, AppointmentState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        );
      case EnumGeneralStateStatus.success:
        List<AppointmentsModel> appointmentList = state.data;

        // Randevu yoksa mesaj göster
        if (appointmentList.isEmpty) {
          return NotFoundAppointment();
        }

        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.23,
              child: Stack(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 10.0,
                    radius: const Radius.circular(6),
                    trackVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        right: 50,
                        top: 8,
                        bottom: 8,
                        left: 8,
                      ),
                      itemCount: appointmentList.length,
                      itemBuilder: (_, i) {
                        final AppointmentsModel appointment =
                            appointmentList[i];
                        bool isRegisterable =
                            appointment.isRegisterable ?? false;
                        _log.d(
                          "Appointment $i - ID: ${appointment.appointmentID}, GUID: ${appointment.gUID}",
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AppointmentCard(
                            branchName: appointment.branchName ?? "",
                            departmentName: appointment.departmentName ?? "",
                            appointmentTime: appointment.appointmentTime ?? "",
                            doctorName: appointment.doctorName ?? "",
                            doctorId: appointment.doctorID,
                            appointmentID: appointment.appointmentID ?? "",
                            guid: appointment.gUID ?? "",
                            isRegisterable: isRegisterable,
                            onCancel: () {
                              _showCancelConfirmation(
                                context,
                                appointment.appointmentID ?? "",
                                appointment.gUID ?? "",
                              );
                            },
                            onTap: () {
                              if (isRegisterable) {
                                NavigationService.ns.routeTo(
                                  "PatientRegistrationProceduresView",
                                  arguments: {
                                    "startStep":
                                        EnumPatientRegistrationProcedures
                                            .doctor,
                                    "model": PatientRegistrationProceduresModel(
                                      branchId: appointment.branchID,
                                      departmentId: appointment.departmentID,
                                      branchName: appointment.branchName,
                                      doctorId: appointment.doctorID,
                                      doctorName: appointment.doctorName,
                                      appointmentId: appointment.appointmentID,
                                    ),
                                  },
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (appointmentList.length > 1)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 50,
                      child: IgnorePointer(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ConstColor.white,
                                ConstColor.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      default:
        return NotFoundAppointment();
    }
  }
}
