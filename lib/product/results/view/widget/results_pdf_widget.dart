import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/user_http_service.dart';
import '../../cubit/results_cubit.dart';
import '../../model/result_file_request_model.dart';
import '../../service/results_search_service.dart';

class ResultsPdfWidget extends StatefulWidget {
  final String reportGUID;
  final String reportName;

  const ResultsPdfWidget({
    super.key,
    required this.reportGUID,
    required this.reportName,
  });

  @override
  State<ResultsPdfWidget> createState() => _ResultsPdfWidgetState();
}

class _ResultsPdfWidgetState extends State<ResultsPdfWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResultsCubit(ResultsService(UserHttpService()))
        ..fetchResultFile(
          ResultFileRequestModel(reportGUID: widget.reportGUID),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.reportName),
          centerTitle: true,
        ),
        body: BlocBuilder<ResultsCubit, ResultsState>(
          builder: (context, state) {
            switch (state.fileStatus) {
              case EnumGeneralStateStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case EnumGeneralStateStatus.success:
                if (state.fileUrl != null && state.fileUrl!.isNotEmpty) {
                  return SfPdfViewer.network(
                    state.fileUrl!,
                    onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('PDF yüklenemedi: ${details.error}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('PDF bulunamadı'),
                  );
                }

              case EnumGeneralStateStatus.failure:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.message ?? 'PDF yüklenirken hata oluştu',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
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
