import 'package:flutter/material.dart';
import 'package:kiosk/product/arrival_opening/view/widget/arrival_opening_button_widget.dart';

class ArrivalOpeningView extends StatefulWidget {
  const ArrivalOpeningView({super.key});

  @override
  State<ArrivalOpeningView> createState() => _ArrivalOpeningViewState();
}

class _ArrivalOpeningViewState extends State<ArrivalOpeningView> {
  @override
  Widget build(BuildContext context) {
    return ArrivalOpeningButtonWidget();
  }
}
