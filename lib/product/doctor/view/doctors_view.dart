import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/widget/loading_widget.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';
import 'package:kiosk/features/utility/user_http_service.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../cubit/doctor_search_cubit.dart';
import '../service/doctor_search_service.dart';
import 'widget/doctors_search_body_widget.dart';

class DoctorSearchView extends StatefulWidget {
  final String sectionId;
  final bool isAppointment;
  const DoctorSearchView({
    super.key,
    required this.sectionId,
    this.isAppointment = false,
  });

  @override
  State<DoctorSearchView> createState() => _DoctorSearchViewState();
}

class _DoctorSearchViewState extends State<DoctorSearchView> {
  @override
  void initState() {
    super.initState();
    if (!widget.isAppointment) {
      context.read<PatientRegistrationProceduresCubit>().autoSelectDoctor();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DoctorSearchCubit>(
      create: (context) => DoctorSearchCubit(
        service: DoctorSearchService(UserHttpService()),
        sectionId: widget.sectionId,
        isAppointment: widget.isAppointment,
      )..fetchDoctors(),
      child: BlocBuilder<DoctorSearchCubit, DoctorSearchState>(
        builder: (context, state) {
          if (widget.isAppointment) {
            return Scaffold(
              appBar: AppBar(title: Text(ConstantString().doctorSelection)),
              body: Padding(
                padding: EdgeInsets.all(20),
                child: _bodyFunc(state, context),
              ),
            );
          }
          return _bodyFunc(state, context);
        },
      ),
    );
  }

  _bodyFunc(DoctorSearchState state, BuildContext context) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return LoadingWidget();
      case EnumGeneralStateStatus.success:
        return DoctorSearchBodyWidget(
          doctorItemList: state.data,
          isAppointment: widget.isAppointment,
        );
      default:
        return Center(
          child: Text(state.message ?? ConstantString().errorOccurred),
        );
    }
  }
}
