import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/user_http_service.dart';
import '../service/results_search_service.dart';
import '../cubit/results_cubit.dart';
import 'widget/results_card_widget.dart';
import 'widget/results_pdf_widget.dart';

class ResultsView extends StatefulWidget {
  const ResultsView({super.key});

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ResultsCubit(ResultsService(UserHttpService()))..fetchResults(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(ConstantString().medicalResults),
          centerTitle: true,
        ),
        body: BlocBuilder<ResultsCubit, ResultsState>(
          builder: (context, state) {
            switch (state.status) {
              case EnumGeneralStateStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case EnumGeneralStateStatus.success:
                if (state.data.isEmpty) {
                  return Center(
                    child: Text(
                      'Henüz sonuç bulunmuyor',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final result = state.data[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ResultsCard(
                        reportName: result.reportName ?? '',
                        reportDate: result.reportDate ?? '',
                        reportStatus: result.reportStatus ?? '',
                        doctorName: result.doctorName ?? '',
                        doctorId: result.doctorID,
                        departmentName: result.departmentName ?? '',
                        onTap: () {
                          if (result.reportGUID != null &&
                              result.reportGUID!.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ResultsPdfWidget(
                                  reportGUID: result.reportGUID!,
                                  reportName: result.reportName ?? 'Sonuç',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Rapor bilgisi bulunamadı'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );

              case EnumGeneralStateStatus.failure:
                return Center(
                  child: Text(
                    state.message ?? ConstantString().unexpectedError,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
