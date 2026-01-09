part of 'patient_login_cubit.dart';

enum PageType { auth, register, verifySms }

enum ScreenType { welcome, auth }

class PatientLoginState {
  final String? message;
  final PageType pageType;
  final ScreenType screenType;
  final EnumGeneralStateStatus status;
  final int? counter;
  final String phoneNumber;
  final String otpCode;
  final String tcNo;
  final String birthDate;
  final String? encryptedUserData;
  final List<SliderModel> sliders;

  const PatientLoginState({
    this.counter,
    this.message,
    this.pageType = PageType.auth,
    this.screenType = ScreenType.welcome,
    this.status = EnumGeneralStateStatus.initial,
    this.phoneNumber = "",
    this.otpCode = "",
    this.tcNo = "",
    this.birthDate = "",
    this.encryptedUserData,
    this.sliders = const [],
  });

  PatientLoginState copyWith({
    String? message,
    PageType? pageType,
    ScreenType? screenType,
    EnumGeneralStateStatus? status,
    int? counter,
    String? phoneNumber,
    String? otpCode,
    String? tcNo,
    String? birthDate,
    String? encryptedUserData,
    List<SliderModel>? sliders,
  }) {
    return PatientLoginState(
      message: message ?? this.message,
      pageType: pageType ?? this.pageType,
      screenType: screenType ?? this.screenType,
      status: status ?? this.status,
      counter: counter ?? this.counter,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      tcNo: tcNo ?? this.tcNo,
      birthDate: birthDate ?? this.birthDate,
      encryptedUserData: encryptedUserData ?? this.encryptedUserData,
      sliders: sliders ?? this.sliders,
    );
  }
}
