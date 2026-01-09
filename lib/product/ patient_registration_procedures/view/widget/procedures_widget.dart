import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../core/utility/analytics_service.dart';
import '../../../../core/utility/session_manager.dart';
import '../../../../core/utility/user_login_status_service.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';
import '../../cubit/patient_registration_procedures_cubit.dart';
import '../../model/patient_registration_procedures_request_model.dart';
import 'info_container_widget.dart';

class ProceduresWidget extends StatelessWidget {
  final Color iColor;
  final Color aColor;
  final TextTheme textTheme;
  final EnumPatientRegistrationProcedures startStep;
  final EnumPatientRegistrationProcedures currentStep;
  final PatientRegistrationProceduresModel model;
  const ProceduresWidget({
    super.key,
    required this.iColor,
    required this.aColor,
    required this.textTheme,
    required this.startStep,
    required this.currentStep,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  topWidget(context),
                  Expanded(child: currentStep.widget(model)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  topWidget(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      color: bg,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final count = EnumPatientRegistrationProcedures.values.length;
                final tileWidth = constraints.maxWidth / count;
                return FixedTimeline.tileBuilder(
                  theme: TimelineThemeData(
                    direction: Axis.horizontal,
                    nodePosition: 0.5,
                    connectorTheme: ConnectorThemeData(
                      thickness: 8,
                      color: context.primaryColor,
                    ),
                    indicatorTheme: IndicatorThemeData(
                      size: 26,
                      color: context.primaryColor,
                    ),
                  ),
                  builder: TimelineTileBuilder.connected(
                    connectionDirection: ConnectionDirection.before,
                    itemCount: count,
                    itemExtent: tileWidth,
                    indicatorBuilder: (_, index) {
                      final reached = index <= currentStep.index;
                      final reachedDone = index <= currentStep.index - 1;
                      return AnimatedScale(
                        scale: reached ? 1.0 : 0.95,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        child: DotIndicator(
                          size: reached ? 34 : 30,
                          color: reached ? context.primaryColor : iColor,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, anim) =>
                                FadeTransition(opacity: anim, child: child),
                            child: Icon(
                              reachedDone ? Icons.check : Icons.circle,
                              key: ValueKey<bool>(reachedDone),
                              size: 20,
                              color: ConstColor.white,
                            ),
                          ),
                        ),
                      );
                    },
                    connectorBuilder: (_, index, __) {
                      final filled = index <= currentStep.index;
                      return TweenAnimationBuilder<Color?>(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                        tween: ColorTween(
                          begin: context.primaryColor,
                          end: filled ? context.primaryColor : iColor,
                        ),
                        builder: (context, color, _) =>
                            SolidLineConnector(color: color),
                      );
                    },
                    contentsBuilder: (context, index) {
                      final reached = index <= currentStep.index;
                      final label =
                          EnumPatientRegistrationProcedures.values[index].label;
                      final baseStyle =
                          textTheme.labelMedium ?? context.caption;
                      final targetStyle = baseStyle.copyWith(
                        fontWeight: reached ? FontWeight.w600 : FontWeight.w400,
                        color: reached ? context.primaryColor : ConstColor.grey,
                      );
                      final content = Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 450),
                            opacity: reached ? 1.0 : 0.7,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 450),
                              style: targetStyle,
                              child: Text(label, textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: content,
                      );
                    },
                    indicatorPositionBuilder: (_, __) => 0.5,
                    contentsAlign: ContentsAlign.basic,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _ButtonBar(currentStep: currentStep, startStep: startStep),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
            ),
            child: InfoContainerWidget(model: model),
          ),
        ],
      ),
    );
  }
}

class _ButtonBar extends StatelessWidget {
  final EnumPatientRegistrationProcedures startStep;
  final EnumPatientRegistrationProcedures currentStep;
  const _ButtonBar({required this.currentStep, required this.startStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        currentStep.isGoBack
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (currentStep == startStep) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      context
                          .read<PatientRegistrationProceduresCubit>()
                          .previousStep();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstColor.grey300,
                    foregroundColor: ConstColor.grey700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: ConstColor.grey700,
                  ),
                  label: Text(
                    currentStep == startStep
                        ? ConstantString().homePageTitle
                        : currentStep.index > 0
                        ? EnumPatientRegistrationProcedures
                              .values[currentStep.index - 1]
                              .label
                        : '',
                    style: context.cardTitle.copyWith(
                      fontSize: 14,
                      color: ConstColor.grey700,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Spacer(),
        if (!(currentStep.isGoBack))
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstColor.transparent,
                foregroundColor: context.primaryColor,
                elevation: 0,
                side: BorderSide(color: context.primaryColor, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () async {
                await context
                    .read<PatientRegistrationProceduresCubit>()
                    .patientTransactionCancel();
                AnalyticsService().trackButtonClicked(
                  'cancel_registration_flow',
                  screenName: 'patient_registration',
                );
                UserLoginStatusService().logout(
                  reason: SessionEndReason.manual,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Iconify(
                    MaterialSymbols.exit_to_app,
                    color: context.primaryColor,
                  ),
                  Text(
                    ConstantString().logout,
                    style: context.buttonText.copyWith(
                      color: context.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
