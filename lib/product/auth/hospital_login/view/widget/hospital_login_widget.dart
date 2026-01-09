import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/widget/custom_button.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../../../features/utility/const/constant_color.dart';
import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/custom_textfield_widget.dart';
import '../../../../../features/utility/enum/enum_textformfield.dart';
import '../../cubit/hospital_login_cubit.dart';

class HospitalLoginWidget extends StatefulWidget {
  final String deviceId;

  const HospitalLoginWidget({super.key, required this.deviceId});

  @override
  State<HospitalLoginWidget> createState() => _HospitalLoginWidgetState();
}

class _HospitalLoginWidgetState extends State<HospitalLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = kReleaseMode
      ? TextEditingController()
      : TextEditingController(text: "buhara");
  final TextEditingController passwordController = kReleaseMode
      ? TextEditingController()
      : TextEditingController(text: "buhara");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstColor.white,
      body: Stack(
        children: [
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ConstColor.red, ConstColor.white, ConstColor.red],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.10,
                  horizontal: MediaQuery.of(context).size.width * 0.20,
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ConstantString.hospitalLogo,
                          width: 150,
                          height: 200,
                        ),
                        CustomTextfieldWidget(
                          type: EnumTextformfield.hospitalUserName,
                          controller: userNameController,
                        ),
                        CustomTextfieldWidget(
                          type: EnumTextformfield.hospitalUserPassword,
                          controller: passwordController,
                        ),
                        CustomButton(
                          label: ConstantString().signIn,
                          backgroundColor: ConstColor.red,
                          height: MediaQuery.of(context).size.height / 12,
                          borderRadius: 20,
                          onPressed: () {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<HospitalLoginCubit>()
                                  .postHospitalLoginCubit(
                                    username: userNameController.text,
                                    password: passwordController.text,
                                  );
                            }
                          },
                        ),
                        // const PdfTestButton(),
                        Center(child: Text(widget.deviceId)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
