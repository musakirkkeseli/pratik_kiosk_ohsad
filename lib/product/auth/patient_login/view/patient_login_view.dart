import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/utility/logger_service.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/custom_input_container.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/enum/enum_textformfield.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../../../../features/widget/app_dialog.dart';
import '../../../../features/widget/circular_countdown.dart';
import '../../../../features/widget/custom_appbar.dart';
import '../../../../features/widget/custom_button.dart';
import '../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../core/utility/language_manager.dart';
import '../cubit/patient_login_cubit.dart';
import '../../../../features/widget/inactivity_warning_dialog.dart';
import '../services/patient_services.dart';
import 'widget/virtual_keypad.dart';
import 'widget/welcome_screen.dart';

class PatientLoginView extends StatefulWidget {
  const PatientLoginView({super.key});

  @override
  State<PatientLoginView> createState() => _PatientLoginViewState();
}

class _PatientLoginViewState extends State<PatientLoginView> {
  bool _dialogOpen = false;
  bool _isOpenVerifyPhoneNumberDialog = false;
  bool _isOpenWarningPhoneNumberDialog = false;
  final ValueNotifier<bool> _validateTc = ValueNotifier<bool>(true);
  // final ValueNotifier<bool> _validateBD = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _validateOtp = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureTc = ValueNotifier<bool>(true);

  final MyLog _log = MyLog("PatientLoginView");

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientLoginCubit>(
      create: (context) =>
          PatientLoginCubit(service: PatientServices(TenantHttpService())),
      child: BlocConsumer<PatientLoginCubit, PatientLoginState>(
        listenWhen: (prev, curr) {
          final counterControl = (prev.counter != 0) && (curr.counter == 0);
          final transition = prev.status != curr.status;
          final enteredWarning =
              ((prev.counter ?? 0) > 15) &&
              ((curr.counter ?? 0) <= 15) &&
              ((curr.counter ?? 0) > 0);

          final leftWarningWhileOpen =
              (_dialogOpen) &&
              ((prev.counter ?? 0) <= 15) &&
              ((curr.counter ?? 0) > 15);

          return counterControl ||
              transition ||
              enteredWarning ||
              leftWarningWhileOpen;
        },
        listener: (context, state) async {
          MyLog.debug("listener counter: ${state.counter}");

          if (state.counter == 0) {
            _clean(context);
            context.read<PatientLoginCubit>().stopCounter();
            Navigator.of(context, rootNavigator: true).maybePop(false);
            SnackbarService().showSnackBar(ConstantString().timeExpired);
            if (_isOpenVerifyPhoneNumberDialog ||
                _isOpenWarningPhoneNumberDialog) {
              Navigator.of(context, rootNavigator: true).maybePop();
            }
          }
          if (state.counter is int) {
            if ((state.counter ?? 0) > 0 &&
                (state.counter ?? 0) <= 15 &&
                !_dialogOpen) {
              _showTimeDialog(context);
            }

            if (_dialogOpen && (state.counter ?? 0) > 15) {
              Navigator.of(context, rootNavigator: true).maybePop();
              _dialogOpen = false;
            }
          }

          switch (state.status) {
            case EnumGeneralStateStatus.loading:
              AppDialog(context).loadingDialog();
            case EnumGeneralStateStatus.success:
              Navigator.pop(context);
              context.read<PatientLoginCubit>().statusInitial();
              if (state.pageType == PageType.auth) {
                if (!_isOpenVerifyPhoneNumberDialog &&
                    !_isOpenWarningPhoneNumberDialog) {
                  _log.d(
                    "_isOpenVerifyPhoneNumberDialog $_isOpenVerifyPhoneNumberDialog // $_isOpenWarningPhoneNumberDialog //result ${!_isOpenVerifyPhoneNumberDialog || !_isOpenWarningPhoneNumberDialog}",
                  );
                  _isOpenVerifyPhoneNumberDialog = true;
                  if (!state.isNewIdCardLogin) {
                    if (state.phoneNumber.length == 10) {
                      verifyPhoneDialog(context, state.phoneNumber);
                    } else {
                      AppDialog(context).infoDialog(
                        ConstantString().warning,
                        ConstantString().phoneNumberNotFound,
                        afterFunc: (onValue) {
                          _isOpenVerifyPhoneNumberDialog = false;
                          _isOpenWarningPhoneNumberDialog = false;
                        },
                      );
                    }
                  }
                }
              }
              break;
            case EnumGeneralStateStatus.failure:
              Navigator.pop(context);
              AppDialog(context).infoDialog(
                ConstantString().errorOccurred,
                state.message ?? ConstantString().errorOccurred,
              );
              context.read<PatientLoginCubit>().statusInitial();
              break;
            default:
          }
        },
        builder: (context, state) {
          return _scaffold(context, state);
        },
      ),
    );
  }

  Widget _scaffold(BuildContext cubitContext, PatientLoginState state) {
    switch (state.screenType) {
      case ScreenType.welcome:
        return WelcomeScreen();
      default:
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              cubitContext.read<PatientLoginCubit>().onChanged('force');
            },
            child: Column(
              spacing: 10,
              children: [
                SizedBox(height: 30),
                CustomAppBar(),
                Consumer<DynamicThemeProvider>(
                  builder: (context, themeProvider, child) {
                    final hospitalName = themeProvider.hospitalName;
                    if (hospitalName.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: context.primaryColor),
                      alignment: Alignment.center,
                      child: Text(
                        hospitalName,
                        style: context.hospitalNameText,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: _body(cubitContext, state),
                  ),
                ),
                const Divider(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      continueButton(cubitContext, state),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          iconColor: ConstColor.red,
                          foregroundColor: ConstColor.red,
                          side: const BorderSide(
                            color: ConstColor.red,
                            width: 1.5,
                          ),
                        ),
                        onPressed: () {
                          _clean(cubitContext);
                        },
                        icon: Iconify(
                          IconParkSolid.clear_format,
                          color: ConstColor.red,
                        ),
                        label: Text(ConstantString().backToTop),
                      ),
                      VirtualKeypad(pageType: state.pageType),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  Column _body(BuildContext cubitContext, PatientLoginState state) {
    switch (state.pageType) {
      case PageType.auth:
        return Column(
          children: [
            const SizedBox(height: 40),
            Text(ConstantString().enterYourTurkishIdNumber),
            ValueListenableBuilder(
              valueListenable: _validateTc,
              builder: (context, validateTcValue, child) {
                return ValueListenableBuilder(
                  valueListenable: _obscureTc,
                  builder: (context, obscureTcValue, child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomInputContainer(
                            type: EnumTextformfield.tc,
                            currentValue: state.tcNo,
                            isValid: validateTcValue,
                            errorMessage: ConstantString().validateTcText,
                            obscureText: obscureTcValue,
                            onToggleVisibility: () {
                              _obscureTc.value = !_obscureTc.value;
                            },
                            child: Text(
                              obscureTcValue && state.tcNo.isNotEmpty
                                  ? obscureTcText(state.tcNo)
                                  : state.tcNo,
                              textAlign: TextAlign.center,
                              style: context.tcLoginText,
                            ),
                          ),
                        ),
                        if (state.tcNo.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height *
                                      0.11 /
                                      2 -
                                  18,
                            ),
                            child: InkWell(
                              onTap: () {
                                _validateTc.value = true;
                                cubitContext
                                    .read<PatientLoginCubit>()
                                    .clearTcNo();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ConstColor.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: ConstColor.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showBarcodeDialog(cubitContext),
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(
                ConstantString().newIdCardLogin,
                style: context.hospitalNameText,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        );
      case PageType.register:
        return Column(
          spacing: 40,
          children: [
            Text(
              ConstantString().pleaseProceedToPatientAdmission,
              style: context.tcLoginText,
            ),
            Expanded(
              child: Center(
                child: Text(
                  ConstantString().patientNotFound,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: ConstColor.grey700),
                ),
              ),
            ),
          ],
        );
      // return Column(
      //   children: [
      //     const SizedBox(height: 40),
      //     Text(ConstantString().enterYourBirthDate),
      //     Row(
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       children: [
      //         Expanded(
      //           child: ValueListenableBuilder(
      //             valueListenable: _validateBD,
      //             builder: (context, validateBDValue, child) {
      //               return CustomInputContainer(
      //                 type: EnumTextformfield.birthday,
      //                 currentValue: state.birthDate,
      //                 isValid: validateBDValue,
      //                 errorMessage:
      //                     ConstantString().pleaseEnterValidBirthDate,
      //                 child: Text(
      //                   state.birthDate.isEmpty ? '' : state.birthDate,
      //                   textAlign: TextAlign.center,
      //                   style: context.birthDayLoginText,
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //         if (state.birthDate.isNotEmpty) const SizedBox(width: 10),
      //         Padding(
      //           padding: EdgeInsets.only(
      //             bottom: MediaQuery.of(context).size.height * 0.11 / 2 - 18,
      //           ),
      //           child: InkWell(
      //             onTap: () {
      //               _validateBD.value = true;
      //               cubitContext.read<PatientLoginCubit>().clearBirthDate();
      //             },
      //             borderRadius: BorderRadius.circular(20),
      //             child: Container(
      //               padding: const EdgeInsets.all(8),
      //               decoration: BoxDecoration(
      //                 color: ConstColor.red.withOpacity(0.1),
      //                 shape: BoxShape.circle,
      //               ),
      //               child: const Icon(
      //                 Icons.close,
      //                 size: 20,
      //                 color: ConstColor.red,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // );
      case PageType.verifySms:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(ConstantString().pleaseEnterSmsCode),
            ),
            CircularCountdown(
              total: Duration(seconds: 150),
              size: 100,
              strokeWidth: 8,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: ConstColor.grey300,
            ),
            ValueListenableBuilder(
              valueListenable: _validateOtp,
              builder: (context, validateOtpValue, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomInputContainer(
                        type: EnumTextformfield.otpCode,
                        currentValue: state.otpCode,
                        isValid: validateOtpValue,
                        errorMessage: ConstantString().validateOTPText,
                        child: Text(
                          state.otpCode,
                          textAlign: TextAlign.center,
                          style: context.otpLoginText,
                        ),
                      ),
                    ),
                    if (state.otpCode.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).size.height * 0.11 / 2 -
                              18,
                        ),
                        child: InkWell(
                          onTap: () {
                            _validateOtp.value = true;
                            cubitContext
                                .read<PatientLoginCubit>()
                                .clearOtpCode();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ConstColor.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 20,
                              color: ConstColor.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        );
    }
  }

  String obscureTcText(String tcNo) {
    MyLog("obscureTcText").d("tcNo: $tcNo");
    int tcNoLength = 0;
    if (tcNo.length <= 3) {
      return tcNo;
    } else if (tcNo.length > 3 && tcNo.length <= 7) {
      tcNoLength = tcNo.length - 3;
      return '${tcNo.substring(0, 3)}${'*' * (tcNoLength)}';
    } else if (tcNo.length > 7) {
      tcNoLength = tcNo.length - 3 - (tcNo.length - 8);
      return '${tcNo.substring(0, 3)}${'*' * (tcNoLength)}${tcNo.substring(8)}';
    }
    return "";
  }

  continueButton(BuildContext cubitContext, PatientLoginState state) {
    Function()? onPressed;
    String label = ConstantString().continueLabel;
    switch (state.pageType) {
      case PageType.verifySms:
        onPressed = () {
          _log.d("otpCode length ${state.otpCode.length}");
          if (state.otpCode.length != 6) {
            _validateOtp.value = false;
          } else {
            _validateOtp.value = true;
            cubitContext.read<PatientLoginCubit>().userLogin();
          }
        };
        break;
      case PageType.auth:
        onPressed = () {
          if (state.tcNo.length != 11) {
            _validateTc.value = false;
          } else {
            final tcError = EnumTextformfieldExtension.validateTC(state.tcNo);
            if (tcError != null) {
              _validateTc.value = false;
              SnackbarService().showSnackBar(tcError);
            } else {
              _validateTc.value = true;
              cubitContext.read<PatientLoginCubit>().validateIdentity();
            }
          }
        };
        break;
      case PageType.register:
        label = ConstantString().backToTop;
        onPressed = () {
          _clean(cubitContext);
        };
        // () {
        //   if (state.birthDate.length != 10) {
        //     _validateBD.value = false;
        //     SnackbarService().showSnackBar(
        //       ConstantString().pleaseEnterValidBirthDate,
        //     );
        //   } else {
        //     final birthDateError = EnumTextformfieldExtension.validateBirthDate(
        //       state.birthDate,
        //     );
        //     if (birthDateError != null) {
        //       _validateBD.value = false;
        //       SnackbarService().showSnackBar(birthDateError);
        //     } else {
        //       _validateBD.value = true;
        //       cubitContext.read<PatientLoginCubit>().userRegister();
        //     }
        //   }
        // };
        break;
    }

    return CustomButton(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.sizeOf(context).width * .5,
      label: label,
      onPressed: onPressed,
    );
  }

  verifyPhoneDialog(BuildContext cubitContext, String phoneNumber) {
    String secretPhoneNumber = phoneNumber.replaceRange(0, 6, "****");
    cubitContext.read<PatientLoginCubit>().statusInitial();
    AppDialog(context).infoDialog(
      ConstantString().isThisNumberYours,
      ConstantString().isThisNumberYoursWithPhone(secretPhoneNumber),
      firstActionText: ConstantString().no,
      firstOnPressed: () {
        NavigationService.ns.goBack();
        _isOpenWarningPhoneNumberDialog = false;
        AppDialog(context).infoDialog(
          ConstantString().warning,
          ConstantString().updatePhoneAtAdmission,
        );
      },
      secondActionText: ConstantString().yes,
      secondOnPressed: () {
        NavigationService.ns.goBack();
        _isOpenWarningPhoneNumberDialog = false;
        cubitContext.read<PatientLoginCubit>().sendOtpCode();
      },
      afterFunc: (onValue) {
        _isOpenVerifyPhoneNumberDialog = false;
        _isOpenWarningPhoneNumberDialog = false;
      },
    );
  }

  _clean(BuildContext ctx) async {
    _obscureTc.value = true;
    _validateTc.value = true;
    _dialogOpen = false;
    _isOpenVerifyPhoneNumberDialog = false;
    _isOpenWarningPhoneNumberDialog;
    _validateOtp.value = true;

    await ctx.setLocale(ConstantString.TR_LOCALE);
    LanguageManager.instance.setLocale(ConstantString.TR_LOCALE);

    ctx.read<PatientLoginCubit>().clean();
  }

  void _showBarcodeDialog(BuildContext cubitContext) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return _BarcodeReaderDialog(
          onBarcodeScanned: (barcode) {
            Navigator.of(dialogContext).pop();
            _log.d("Okutulan barkod: $barcode");
            // Barkodu işle - örneğin TC No olarak ayarla
            if (barcode.length == 11) {
              cubitContext.read<PatientLoginCubit>().setTcNo(barcode);
              final tcError = EnumTextformfieldExtension.validateTC(barcode);
              if (tcError != null) {
                SnackbarService().showSnackBar(tcError);
              } else {
                cubitContext.read<PatientLoginCubit>().directLogin();
              }
            } else {
              SnackbarService().showSnackBar(
                "${ConstantString().invalidBarcode}: $barcode",
              );
            }
          },
        );
      },
    );
  }

  void _showTimeDialog(BuildContext cubitContext) {
    _dialogOpen = true;
    final cubit = cubitContext.read<PatientLoginCubit>();
    Navigator.of(context)
        .push(
          RawDialogRoute(
            pageBuilder: (dialogcontext, animation, secondaryAnimation) {
              return BlocProvider.value(
                value: cubit,
                child: BlocBuilder<PatientLoginCubit, PatientLoginState>(
                  builder: (dialogCtx, s) {
                    final int remaining = s.counter ?? 0;
                    return InactivityWarningDialog(
                      remaining: Duration(seconds: remaining),
                      secondaryLabel: ConstantString().close,
                      onContinue: () {
                        dialogCtx.read<PatientLoginCubit>().onChanged('force');
                        NavigationService.ns.goBack();
                        _dialogOpen = false;
                      },
                    );
                  },
                ),
              );
            },
          ),
        )
        .then((onValue) {
          if (onValue == false) {
            _dialogOpen = false;
          } else {
            _dialogOpen = false;
            cubitContext.read<PatientLoginCubit>().onChanged('force');
          }
        });
  }
}

class _BarcodeReaderDialog extends StatefulWidget {
  final Function(String barcode) onBarcodeScanned;

  const _BarcodeReaderDialog({required this.onBarcodeScanned});

  @override
  State<_BarcodeReaderDialog> createState() => _BarcodeReaderDialogState();
}

class _BarcodeReaderDialogState extends State<_BarcodeReaderDialog> {
  String _scannedBarcode = '';
  String _displayBarcode = '';
  Timer? _debounceTimer;
  final FocusNode _focusNode = FocusNode();
  final MyLog _log = MyLog("BarcodeReaderDialog");

  @override
  void initState() {
    super.initState();
    // Dialog açıldığında focus'u al
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _log.d("Key event: ${event.logicalKey} - Character: ${event.character}");

      // Enter veya Return tuşuna basıldıysa barkodu işle
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_scannedBarcode.isNotEmpty) {
          _log.d("Barkod tamamlandı: $_scannedBarcode");
          widget.onBarcodeScanned(_scannedBarcode);
          _scannedBarcode = '';
          _displayBarcode = '';
        }
        return;
      }

      // Eğer karakter varsa ekle
      final character = event.character;
      if (character != null && character.isNotEmpty) {
        setState(() {
          _scannedBarcode += character;
          _displayBarcode += character;
        });

        // Debounce timer - Barkod okuyucu hızlı gönderir,
        // ama kullanıcı manuel giriş yaparsa temizle
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          // Eğer 500ms içinde yeni karakter gelmezse (manuel giriş olabilir)
          // ve barkod Enter ile onaylanmadıysa, tamponu temizle
          if (mounted) {
            setState(() {
              _scannedBarcode = '';
              _displayBarcode = 'Zaman aşımı - Tekrar okutun';
            });
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _displayBarcode = '';
                });
              }
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ConstantString().newIdCardLogin,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ConstColor.grey300,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.primaryColor, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 120,
                          color: context.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          ConstantString().newIdCardScanInstruction,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (_displayBarcode.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _displayBarcode,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Klavye girişi algılanıyor...',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: ConstColor.grey700),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kapat', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
