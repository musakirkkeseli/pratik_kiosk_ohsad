import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../cubit/appointment_slot_cubit.dart';
import 'slot_time_grid_widget.dart';

class AppointmentSlotBodyWidget extends StatelessWidget {
  final String doctorName;
  final String departmentName;
  final AppointmentSlotState state;

  const AppointmentSlotBodyWidget({
    super.key,
    required this.doctorName,
    required this.departmentName,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Geri Butonu
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: IconButton(
        //       onPressed: () => Navigator.of(context).pop(),
        //       icon: const Icon(Icons.arrow_back, size: 32),
        //       style: IconButton.styleFrom(
        //         backgroundColor: ConstColor.grey200,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(vertical: 20),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${ConstantString().sectionName}: $departmentName',
                style: context.cardTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                '${ConstantString().doctorName}: $doctorName',
                style: context.bodyPrimary.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
        Expanded(child: _buildSlotsList(context)),
      ],
    );
  }

  Widget _buildSlotsList(BuildContext context) {
    if (state.status == EnumGeneralStateStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.slots == null || state.slots!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              ConstantString().noAvailableAppointmentsForDoctor,
              style: context.notFoundText,
            ),
          ],
        ),
      );
    }

    // Slotları tarihe göre grupla
    final groupedSlots = <String, List<dynamic>>{};
    for (var slot in state.slots!) {
      final date = slot.getFormattedDate();
      if (!groupedSlots.containsKey(date)) {
        groupedSlots[date] = [];
      }
      groupedSlots[date]!.add(slot);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: groupedSlots.isNotEmpty
          ? groupedSlots.length + 1
          : groupedSlots.length,
      itemBuilder: (context, index) {
        // Son elemandan sonra boşluk ekle
        if (index == groupedSlots.length) {
          return const SizedBox(height: 100);
        }

        final date = groupedSlots.keys.elementAt(index);
        final slots = groupedSlots[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarih başlığı
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                date,
                style: context.cardTitle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SlotTimeGridWidget(
              slots: slots.cast(),
              selectedSlotId: state.selectedSlotId ?? '',
              doctorName: doctorName,
              departmentName: departmentName,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
