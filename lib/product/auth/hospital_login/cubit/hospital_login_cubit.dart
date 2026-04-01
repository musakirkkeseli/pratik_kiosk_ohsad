import 'package:flutter/foundation.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';
import 'package:pratik_pos_integration/pratik_pos_integration.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/analytics_service.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../core/utility/login_status_service.dart';
import '../../../../core/utility/sentry_service.dart';
import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../model/config_response_model.dart';
import '../model/hospital_login_request_model.dart';
import '../model/hospital_login_response_model.dart';
import '../services/IHospital_and_user_login_services.dart';

part 'hospital_login_state.dart';

class HospitalLoginCubit extends BaseCubit<HospitalLoginState> {
  final String kioskDeviceId;
  final IHospitalAndUserLoginServices service;
  HospitalLoginCubit({required this.service, required this.kioskDeviceId})
    : super(HospitalLoginState());

  final MyLog _log = MyLog('HospitalLoginCubit');

  void _trackButton(String name, {Map<String, dynamic>? extra}) {
    AnalyticsService().trackButtonClicked(
      name,
      screenName: 'hospital_login',
      extra: extra,
    );
  }

  Future<void> postHospitalLoginCubit({
    required String username,
    required String password,
  }) async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    _trackButton(
      'hospital_login_submit',
      extra: {'username_length': username.length},
    );
    HospitalLoginRequestModel requestModel = HospitalLoginRequestModel(
      username: username,
      password: password,
      kioskDeviceId: kioskDeviceId,
    );
    try {
      final resp = await service.postLogin(requestModel);

      if (resp.success && (resp.data is HospitalLoginResponseModel)) {
        HospitalLoginResponseModel hospitalLoginModel = resp.data!;
        Tokens tokens = hospitalLoginModel.tokens ?? Tokens();
        final access = tokens.accessToken;
        final refresh = tokens.refreshToken;
        if (access != null || refresh != null) {
          _log.d("$access");

          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              loginStatus: EnumHospitalLoginStatus.config,
              message: resp.message,
            ),
          );
          await LoginStatusService().saveToken(
            accessToken: access ?? "",
            refreshToken: refresh ?? "",
          );
          config();
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
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

  Future<void> config() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final resp = await service.getConfig();

      if (resp.success && resp.data is ConfigResponseModel) {
        ConfigResponseModel configResponseModel =
            resp.data ?? ConfigResponseModel();

        // ✅ Sentry'ye hastane bilgilerini set et
        final hospitalName =
            configResponseModel.hospitalName ?? 'Unknown Hospital';
        SentryService().setHospitalContext(
          hospitalName: hospitalName,
          kioskDeviceId: kioskDeviceId,
        );
        _log.i('Sentry context set: $hospitalName - $kioskDeviceId');

        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            message: resp.message,
          ),
        );
        DynamicThemeProvider().updateTheme(configResponseModel);
        await Future.delayed(const Duration(milliseconds: 5000));
        final posConfig = configResponseModel.posConfig;
        if (posConfig is PosConfig) {
          // SocketService _socket = SocketService();
          // _socket.connect();
          // _socket.posConfigure();
          await PosService.instance.configure(posConfig, useMock: kDebugMode);
          safeEmit(state.copyWith(posConfig: posConfig));
          await posConfiguration();
        } else {
          SnackbarService().showSnackBar(
            "Pos yapılandırma bilgileri alınamadı. Pratik bilişim ile iletişime geçiniz.",
          );
          await LoginStatusService().logout();
        }
        // PosConfig(
        //   baseUrl: 'http://10.25.1.204:8090',
        //   posIpAddress: '192.168.3.72',
        //   serialNumber: 'PAV860049953',
        //   pavoUrl: 'https://192.168.3.72',
        //   authToken: 'Yml6QWRtaW46MTFxcTIyV1ch',
        // );
      } else {
        await LoginStatusService().logout();
      }
    } on NetworkException {
      await LoginStatusService().logout();
    } catch (e) {
      await LoginStatusService().logout();
    }
  }

  Future<void> posConfiguration() async {
    try {
      final response = await PosService.instance.pairing();

      if (response.success) {
        await LoginStatusService().login();
      } else {
        SnackbarService().showSnackBar(
          response.message ?? 'POS eşleme başarısız',
        );
        safeEmit(
          state.copyWith(loginStatus: EnumHospitalLoginStatus.posConfiguration),
        );
      }
    } on PosException catch (e) {
      SnackbarService().showSnackBar('POS eşleme başarısız ${e.message}');
      safeEmit(
        state.copyWith(loginStatus: EnumHospitalLoginStatus.posConfiguration),
      );
    } catch (e) {
      SnackbarService().showSnackBar('POS eşleme başarısız $e');
      safeEmit(
        state.copyWith(loginStatus: EnumHospitalLoginStatus.posConfiguration),
      );
    }
  }
}
