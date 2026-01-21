import 'dart:async';

import 'package:kiosk/features/utility/const/constant_string.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/analytics_service.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../core/utility/user_login_status_service.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../model/patient_login_request_model.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';
import '../model/patient_validate_identity_response_model.dart';
import '../model/slider_model.dart';
import '../services/IPatientServices.dart';

part 'patient_login_state.dart';

class PatientLoginCubit extends BaseCubit<PatientLoginState> {
  final IPatientServices service;
  PatientLoginCubit({required this.service}) : super(PatientLoginState());

  final MyLog _log = MyLog('PatientLoginCubit');

  void _trackButton(String name, {Map<String, dynamic>? extra}) {
    AnalyticsService().trackButtonClicked(
      name,
      screenName: 'patient_login',
      extra: extra,
    );
  }

  void gotoAuth() {
    safeEmit(state.copyWith(screenType: ScreenType.auth));
    onChanged("force");
  }

  Future<void> fetchSliders() async {
    try {
      final resp = await service.getSliders();
      if (resp.success == true && resp.data != null && resp.data!.isNotEmpty) {
        _log.d('Sliders loaded: ${resp.data!.length}');
        safeEmit(state.copyWith(sliders: resp.data));
      } else {
        _log.e('Failed to load sliders: ${resp.message}');
      }
    } on NetworkException catch (e) {
      _log.e('NetworkException while fetching sliders: ${e.message}');
    } catch (e) {
      _log.e('Error fetching sliders: $e');
    }
  }

  Future<void> directLogin() async {
    _startOrResetTimer();
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    _trackButton('direct_patient_login_submit');
    try {
      final resp = await service.postDirectLogin(state.tcNo);

      if (resp.success && resp.data is PatientResponseModel) {
        String? accessToken = resp.data!.accessToken;
        if (accessToken is String) {
          _log.d("data doğru");

          final patientName = resp.data!.patientData?.name ?? "";
          final patientSurname = resp.data!.patientData?.surname ?? "";
          final identityNo = resp.data!.patientData?.identityNo ?? "";

          UserLoginStatusService().login(
            accessToken: accessToken,
            name: patientName,
            surname: patientSurname,
            userId: 1,
            tcNo: identityNo,
          );
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
              isNewIdCardLogin: true,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      switch (e.statusCode) {
        case 400:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: e.message,
              pageType: PageType.register,
            ),
          );
          break;
        default:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: e.message,
            ),
          );
      }
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> userLogin() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    _trackButton(
      'patient_login_submit',
      extra: {
        'otp_length': state.otpCode.length,
        'encrypted_payload': state.encryptedUserData?.isNotEmpty == true,
      },
    );
    PatientLoginRequestModel patientLoginRequestModel =
        PatientLoginRequestModel(
          encryptedUserData: state.encryptedUserData,
          otpCode: state.otpCode,
        );
    try {
      final resp = await service.postUserLogin(patientLoginRequestModel);

      if (resp.success && resp.data is PatientResponseModel) {
        String? accessToken = resp.data!.accessToken;
        if (accessToken is String) {
          _log.d("data doğru");

          final patientName = resp.data!.patientData?.name ?? "";
          final patientSurname = resp.data!.patientData?.surname ?? "";
          final identityNo = resp.data!.patientData?.identityNo ?? "";

          UserLoginStatusService().login(
            accessToken: accessToken,
            name: patientName,
            surname: patientSurname,
            userId: 1,
            tcNo: identityNo,
          );
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      switch (e.statusCode) {
        case 400:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: e.message,
              pageType: PageType.register,
            ),
          );
          break;
        default:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: e.message,
            ),
          );
      }
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> userRegister() async {
    _startOrResetTimer();
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    _trackButton(
      'patient_register_submit',
      extra: {'birth_date_filled': state.birthDate.isNotEmpty},
    );

    try {
      final resp = await service.postUserRegister(
        PatientRegisterRequestModel(
          tcNo: state.tcNo,
          birthDate: state.birthDate,
        ),
      );

      if (resp.success && resp.data is PatientResponseModel) {
        String? accessToken = resp.data!.accessToken;
        if (accessToken is String) {
          _log.d("data doğru");

          // Patient data'dan name ve surname'i al
          final patientName = resp.data!.patientData?.name ?? "";
          final patientSurname = resp.data!.patientData?.surname ?? "";

          UserLoginStatusService().login(
            accessToken: accessToken,
            name: patientName,
            surname: patientSurname,
            userId: 1,
            tcNo: "",
          );
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: '${ConstantString().errorOccurred}: $e',
        ),
      );
    }
  }

  Future<void> validateIdentity() async {
    _startOrResetTimer();
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    _trackButton(
      'patient_validate_identity',
      extra: {'tc_entered': state.tcNo.isNotEmpty},
    );
    try {
      final resp = await service.postValidateIdentify(state.tcNo);

      if (resp.success && resp.data is PatientValidateIdentityResponseModel) {
        String? phoneNumber = resp.data!.phoneNumber;
        String? encryptedUserData = resp.data!.encryptedUserData;
        if (encryptedUserData is String) {
          _log.d("data doğru");
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
              phoneNumber: phoneNumber,
              encryptedUserData: encryptedUserData,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      switch (e.statusCode) {
        case 400:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: e.message,
              pageType: PageType.register,
            ),
          );
          break;
        default:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: e.message,
            ),
          );
      }
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> sendOtpCode() async {
    _startOrResetTimer();
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    _trackButton(
      'patient_send_otp',
      extra: {'encrypted_payload': state.encryptedUserData?.isNotEmpty == true},
    );
    String? encryptedUserData = state.encryptedUserData;
    if (encryptedUserData is String) {
      try {
        final resp = await service.postSendLoginOtp(encryptedUserData);

        if (resp.success) {
          _log.d("data doğru");
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
              pageType: PageType.verifySms,
            ),
          );
          _startOrResetTimer();
          _startOTPTimer();
        } else {
          _log.d("data yanlış");
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } on NetworkException catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: e.message,
          ),
        );
      } catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: ConstantString().errorOccurred,
          ),
        );
      }
    }
  }

  void clean() {
    safeEmit(
      state.copyWith(
        tcNo: "",
        otpCode: "",
        birthDate: "",
        pageType: PageType.auth,
        screenType: ScreenType.welcome,
        phoneNumber: "",
        encryptedUserData: null,
        counter: null,
        status: EnumGeneralStateStatus.initial,
      ),
    );
    stopCounter();
  }

  void clearTcNo() {
    safeEmit(state.copyWith(tcNo: ""));
  }

  void setTcNo(String tcNo) {
    safeEmit(state.copyWith(tcNo: tcNo));
  }

  void clearOtpCode() {
    safeEmit(state.copyWith(otpCode: ""));
  }

  void clearBirthDate() {
    safeEmit(state.copyWith(birthDate: ""));
  }

  void onChangeBirthDate(String value) {
    String birthDate = state.birthDate;
    String newBirthDate = birthDate;

    // 🔹 Eğer kullanıcı 3. karakteri yazmak üzereyse ama '/' silinmişse,
    //    gün kısmının sonuna '/' otomatik eklenir.
    if ((birthDate.length == 2 || birthDate.length == 5) &&
        !birthDate.endsWith('/')) {
      newBirthDate += '/';
    }

    // 🔹 Yeni karakteri ekle
    newBirthDate += value;

    // 🔹 Maksimum uzunluk (gg/aa/yyyy = 10)
    if (newBirthDate.length > 10) return;

    // 🔹 Otomatik '/' ekleme noktaları
    if (newBirthDate.length == 2 || newBirthDate.length == 5) {
      newBirthDate += '/';
    }

    // 🔹 Gün - Ay - Yıl kontrolü (basitleştirilmiş)
    List<String> parts = newBirthDate.split('/');
    if (parts.isNotEmpty && parts[0].length == 1) {
      int? dayOne = int.tryParse(parts[0]);
      if (dayOne == null || dayOne < 0 || dayOne > 3) return;
    }
    if (parts.isNotEmpty && parts[0].length == 2) {
      int? day = int.tryParse(parts[0]);
      if (day == null || day < 1 || day > 31) return;
    }
    if (parts.length > 1 && parts[1].length == 1) {
      int? month = int.tryParse(parts[1]);
      if (month == null || (month != 1 && month != 0)) return;
    }
    if (parts.length > 1 && parts[1].length == 2) {
      int? month = int.tryParse(parts[1]);
      if (month == null || month < 1 || month > 12) return;
    }

    safeEmit(state.copyWith(birthDate: newBirthDate));
    _startOrResetTimer();
  }

  void deleteBirthDate() {
    String birthDate = state.birthDate;
    if (birthDate.isEmpty) return;
    birthDate = birthDate.substring(0, birthDate.length - 1);
    if (birthDate.endsWith('/')) {
      birthDate = birthDate.substring(0, birthDate.length - 1);
    }

    safeEmit(state.copyWith(birthDate: birthDate));
  }

  statusInitial() {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.initial));
  }

  Timer? _timer;
  Timer? _otpTimer;

  void onChanged(String value) {
    if (value.isEmpty) {
      _stopTimer();
      safeEmit(state.copyWith(counter: null));
      return;
    }
    _startOrResetTimer();
  }

  void onChangeTcNo(String value) {
    String? tcNo = state.tcNo;
    tcNo = "$tcNo$value";

    // 11 haneli sınır kontrolü
    if (tcNo.length > 11) {
      return;
    }

    safeEmit(state.copyWith(tcNo: tcNo));
    _startOrResetTimer();
  }

  void deleteTcNo() {
    String? tcNo = state.tcNo;
    if (tcNo.isEmpty) return;
    tcNo = tcNo.substring(0, tcNo.length - 1);
    safeEmit(state.copyWith(tcNo: tcNo));
  }

  void onChangeOtpCode(String value) {
    String? otpCode = state.otpCode;
    otpCode = "$otpCode$value";

    // 6 haneli sınır kontrolü
    if (otpCode.length > 6) {
      return;
    }

    safeEmit(state.copyWith(otpCode: otpCode));
    _startOrResetTimer();
  }

  void deleteOtpCode() {
    String? otpCode = state.otpCode;
    if (otpCode.isEmpty) return;
    otpCode = otpCode.substring(0, otpCode.length - 1);
    safeEmit(state.copyWith(otpCode: otpCode));
  }

  void _startOrResetTimer() {
    _timer?.cancel();
    switch (state.pageType) {
      case PageType.auth:
        safeEmit(state.copyWith(counter: 30));
        break;
      case PageType.register:
        safeEmit(state.copyWith(counter: 30));
        break;
      case PageType.verifySms:
        safeEmit(state.copyWith(counter: 150));
        break;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final counter = state.counter;
      _log.d("counter: $counter");
      if (counter is int) {
        if (counter <= 1) {
          _stopTimer();
          safeEmit(state.copyWith(counter: 0));
          return;
        }
        safeEmit(state.copyWith(counter: counter - 1));
      }
    });
  }

  void _startOTPTimer() {
    if (state.pageType == PageType.verifySms) {
      _otpTimer?.cancel();
      int otpCounter = 150;
      _otpTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        otpCounter -= 1;
        _log.d("otpCounter: $otpCounter");
        if (otpCounter <= 1) {
          // _stopOtpTimer();
          // _stopTimer();
          safeEmit(state.copyWith(counter: 0));
          return;
        }
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _stopOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  void stopCounter() {
    _stopTimer();
    _stopOtpTimer();
    safeEmit(state.copyWith(counter: null));
  }

  @override
  Future<void> close() {
    _stopTimer();
    _stopOtpTimer();
    return super.close();
  }
}
