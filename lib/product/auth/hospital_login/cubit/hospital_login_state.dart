part of 'hospital_login_cubit.dart';

enum EnumHospitalLoginStatus { login, config, posConfiguration }

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final EnumHospitalLoginStatus loginStatus;
  final String? message;
  final PosConfig? posConfig;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.loginStatus = EnumHospitalLoginStatus.login,
    this.message,
    this.posConfig,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    EnumHospitalLoginStatus? loginStatus,
    String? message,
    PosConfig? posConfig,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
      posConfig: posConfig ?? this.posConfig,
    );
  }
}
