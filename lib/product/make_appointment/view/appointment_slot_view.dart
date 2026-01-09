import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';
import 'package:mylog/mylog.dart';

import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/navigation_service.dart';
import '../../../features/utility/user_http_service.dart';
import '../cubit/appointment_slot_cubit.dart';
import '../service/makeAppointmentServices.dart';
import 'widget/appointment_slot_body_widget.dart';

class AppointmentSlotView extends StatefulWidget {
  final int doctorId;
  final int departmentId;
  final String doctorName;
  final String departmentName;

  const AppointmentSlotView({
    super.key,
    required this.doctorId,
    required this.departmentId,
    required this.doctorName,
    required this.departmentName,
  });

  @override
  State<AppointmentSlotView> createState() => _AppointmentSlotViewState();
}

class _AppointmentSlotViewState extends State<AppointmentSlotView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentSlotCubit(
        service: MakeAppointmentService(UserHttpService()),
        doctorId: widget.doctorId,
        departmentId: widget.departmentId,
        doctorName: widget.doctorName,
        departmentName: widget.departmentName,
      )..fetchEmptySlots(),
      child: BlocConsumer<AppointmentSlotCubit, AppointmentSlotState>(
        listenWhen: (previous, current) {
          MyLog.debug('\n========== LISTEN WHEN ==========');
          MyLog.debug('Previous status: ${previous.status}');
          MyLog.debug('Current status: ${current.status}');
          MyLog.debug(
            'Previous appointmentBooked: ${previous.appointmentBooked}',
          );
          MyLog.debug(
            'Current appointmentBooked: ${current.appointmentBooked}',
          );
          MyLog.debug('Previous appointmentId: ${previous.appointmentId}');
          MyLog.debug('Current appointmentId: ${current.appointmentId}');

          // appointmentBooked flag'ini kontrol et veya failure durumu
          final shouldListen =
              (!previous.appointmentBooked && current.appointmentBooked) ||
              (previous.status == EnumGeneralStateStatus.loading &&
                  current.status == EnumGeneralStateStatus.failure);

          return shouldListen;
        },
        listener: (context, state) {
          if (state.appointmentBooked) {
            _showSuccessDialog(context);
          } else if (state.status == EnumGeneralStateStatus.failure) {
            _showErrorDialog(context, state.errorMessage ?? 'Bir hata oluştu');
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(ConstantString().takeAppointment)),
            body: AppointmentSlotBodyWidget(
              doctorName: widget.doctorName,
              departmentName: widget.departmentName,
              state: state,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                (state.slots != null && state.slots!.isNotEmpty)
                ? Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (state.selectedSlotId != null &&
                            state.selectedSlotId!.isNotEmpty) {
                          _showConfirmDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            state.selectedSlotId != null &&
                                state.selectedSlotId!.isNotEmpty
                            ? Theme.of(context).primaryColor
                            : ConstColor.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        ConstantString().takeAppointment,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              state.selectedSlotId != null &&
                                  state.selectedSlotId!.isNotEmpty
                              ? ConstColor.white
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            ConstantString().success,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              Text(
                ConstantString().appointmentBookedMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  NavigationService.ns.gotoMain();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  ConstantString().close,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            ConstantString().error,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: ConstColor.red, size: 80),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  ConstantString().ok,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final cubit = context.read<AppointmentSlotCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          ConstantString().confirm,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(ConstantString().doctorName, widget.doctorName),
            const SizedBox(height: 12),
            _buildInfoRow(ConstantString().sectionName, widget.departmentName),
            const SizedBox(height: 12),
            _buildInfoRow(ConstantString().date, cubit.selectedDate ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow(ConstantString().time, cubit.selectedTime ?? ''),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              ConstantString().cancel,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.confirmAppointment();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              ConstantString().confirm,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
