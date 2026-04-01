import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import '../../../../../features/utility/const/constant_color.dart';
import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/extension/text_theme_extension.dart';

class ConfigWidget extends StatefulWidget {
  const ConfigWidget({super.key});

  @override
  State<ConfigWidget> createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ConstColor.logoNavyColor, ConstColor.white, ConstColor.logoNavyColor],
              ),
              backgroundBlendMode: BlendMode.srcOver,
            ),
            child: PlasmaRenderer(
              type: PlasmaType.infinity,
              particles: 10,
              color: ConstColor.prizmaColor,
              blur: 0.4,
              size: 1,
              speed: 3.75,
              offset: 0,
              blendMode: BlendMode.plus,
              particleType: ParticleType.atlas,
              variation1: 0,
              variation2: 0,
              variation3: 0,
              rotation: 0,
            ),
          ),
        ),
        Center(
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(ConstantString.bankoAsistLogo, width: 200, height: 200),
              Lottie.asset(
                ConstantString.configSetting,
                width: 180,
                height: 180,
                fit: BoxFit.contain,
                repeat: true,
              ),
              SizedBox(height: 20),
              Text(
                ConstantString().settingsApplying,
                textAlign: TextAlign.center,
                style: context.sectionTitle.copyWith(
                  color: ConstColor.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
