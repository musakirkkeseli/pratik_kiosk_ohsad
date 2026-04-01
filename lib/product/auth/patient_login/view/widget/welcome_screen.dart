import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import 'package:kiosk/features/widget/insurance_logo_carousel.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../../core/widget/custom_image.dart';
import '../../../../../features/utility/const/constant_color.dart';
import '../../../../../features/utility/const/constant_string.dart';
import '../../cubit/patient_login_cubit.dart';
import 'language_button_widget2.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;
  int _lastSliderCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientLoginCubit>().fetchSliders();
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide(int itemCount) {
    if (_sliderTimer != null || itemCount <= 1) {
      return;
    }
    _sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _currentPage = (_currentPage + 1) % itemCount;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicThemeProvider>(context);
    final qrCodeUrl = themeProvider.qrCodeUrl;
    final primaryColor = context.primaryColor;

    return Scaffold(
      backgroundColor: ConstColor.white,
      body: Column(
        children: [
          _slider(context, this),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const InsuranceLogoCarousel(),
                  const SizedBox(height: 90),
                  _startWidget(context, primaryColor),
                  const SizedBox(height: 80),
                  LanguageButtonWidget2(cubitContext: context),
                  const SizedBox(height: 80),
                  _mobilAppQR(qrCodeUrl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _startWidget(BuildContext context, Color primaryColor) {
  return GestureDetector(
    onTap: () {
      try {
        context.read<PatientLoginCubit>().gotoAuth();
      } catch (_) {}
    },
    child: Column(
      children: [
        _buildStartButton(context, primaryColor),
        const SizedBox(height: 40),
        _buildActionCards(primaryColor),
      ],
    ),
  );
}

Widget _buildStartButton(BuildContext context, Color primaryColor) {
  return Column(
    children: [
      Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ConstColor.white,
          border: Border.all(color: primaryColor, width: 4),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedPlay,
            color: primaryColor,
            size: 100,
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(
        ConstantString().start,
        style: TextStyle(
          color: primaryColor,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildActionCards(Color primaryColor) {
  final actions = [
    {
      'icon': HugeIcons.strokeRoundedUserAdd02,
      'title': ConstantString().appointmentRegistration,
      'isHugeIcon': true,
    },
    {
      'icon': HugeIcons.strokeRoundedCalendar03,
      'title': ConstantString().patientRegistration,
      'isHugeIcon': true,
    },
    {
      'icon': HugeIcons.strokeRoundedCalendar01,
      'title': ConstantString().takeAppointment,
      'isHugeIcon': true,
    },
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 100),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                actions[0]['icon'],
                actions[0]['title'] as String,
                primaryColor,
                isHugeIcon: actions[0]['isHugeIcon'] as bool,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildActionCard(
                actions[1]['icon'],
                actions[1]['title'] as String,
                primaryColor,
                isHugeIcon: actions[1]['isHugeIcon'] as bool,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildActionCard(
                actions[2]['icon'],
                actions[2]['title'] as String,
                primaryColor,
                isHugeIcon: actions[2]['isHugeIcon'] as bool,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildActionCard(
  dynamic icon,
  String title,
  Color primaryColor, {
  bool isHugeIcon = false,
}) {
  return Container(
    height: 180,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: ConstColor.white,
      borderRadius: BorderRadius.circular(16),
      // border: Border.all(
      //   color: primaryColor.withOpacity(0.3),
      //   width: 1,
      // ),
      // boxShadow: [
      //   BoxShadow(
      //     color: ConstColor.black.withOpacity(0.05),
      //     blurRadius: 8,
      //     offset: const Offset(0, 2),
      //   ),
      // ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isHugeIcon
            ? HugeIcon(icon: icon, size: 55, color: primaryColor)
            : Icon(icon as IconData, size: 55, color: primaryColor),
        const SizedBox(height: 16),
        SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _slider(BuildContext context, _WelcomeScreenState sliderState) {
  return BlocBuilder<PatientLoginCubit, PatientLoginState>(
    builder: (_, state) {
      final sliders = state.sliders;
     

      if (sliders.isNotEmpty && sliders.length > 1) {
        if (sliderState._lastSliderCount != sliders.length) {
          sliderState._lastSliderCount = sliders.length;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            sliderState._startAutoSlide(sliders.length);
          });
        }
      }

      if (sliders.isEmpty) {
        return Container(
          height: 200,
          width: double.infinity,
          color: ConstColor.black,
          child: CustomImage.image(
            "https://kiosk.prtk.gen.tr/assets/images/sliders/kioskSlider.png",
            CustomImageType.standart,
            fit: BoxFit.cover,
          ),
        );
      }

      return SizedBox(
        height: 220,
        width: double.infinity,
        child: PageView(
          controller: sliderState._pageController,
          onPageChanged: (index) {
            sliderState._currentPage = index;
          },
          children: sliders.map((slider) {
            return CustomImage.image(
              slider.path ?? "",
              CustomImageType.standart,
              fit: BoxFit.cover,
            );
          }).toList(),
        ),
      );
    },
  );
}

Widget _mobilAppQR(String qrCodeUrl) {
  if (qrCodeUrl.isEmpty) {
    return const SizedBox.shrink();
  }
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 40,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ConstColor.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ConstColor.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: CachedNetworkImage(
            imageUrl: qrCodeUrl,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          ),
        ),
        Image.asset(ConstantString.appstoreLight, width: 150, height: 120),
        Image.asset(ConstantString.googlePlayLight, width: 150, height: 120),
      ],
    ),
  );
}
