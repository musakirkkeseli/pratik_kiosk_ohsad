import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

import '../cubit/results_cubit.dart';
import 'widget/results_card_widget.dart';

class ResultsView extends StatefulWidget {
  const ResultsView({super.key});

  @override
  State<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ConstantString().results)),
      body: BlocConsumer<ResultsCubit, ResultsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResultsCard(),
            ),
          );
        },
      ),
    );
  }
}
