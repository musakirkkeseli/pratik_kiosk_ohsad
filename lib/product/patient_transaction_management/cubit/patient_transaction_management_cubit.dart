import 'package:mylog/mylog.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/patient_transaction_model.dart';
import '../model/refund_otp_verify_request_model.dart';
import '../model/refund_otp_verify_response_model.dart';
import '../model/refund_send_otp_response_model.dart';
import '../../patient_transaction_management/service/IPatientTransactionManagementService.dart';

part 'patient_transaction_management_state.dart';

class PatientTransactionManagementCubit
    extends BaseCubit<PatientTransactionManagementState> {
  final IPatientTransactionManagementService service;
  PatientTransactionManagementCubit(this.service)
    : super(PatientTransactionManagementState());

  final MyLog _log = MyLog("PatientTransactionManagementCubit");

  fecthPatientTransactionManagement() async {
    _log.d("fecthPatientTransactionManagement called");
    try {
      final response = await service.getPatientTransactionList();
      if (response.success == true &&
          response.data is List<PatientTransactionModel>) {
        if ((response.data ?? []).isEmpty) {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: response.message,
            ),
          );
        } else {
          // (response.data ?? [])[0].revenues![0].processName = "Muayene Ücreti";
          // (response.data ?? [])[0].time = "14:30";
          // (response.data ?? [])[0].date = DateFormat(
          //   'dd MMMM yyyy',
          //   'tr_TR',
          // ).format(DateTime.now());
          // (response.data ?? [])[0].branchName = "Kardiyoloji";
          // (response.data ?? [])[0].doctorName = "Dr. Mehmet Yılmaz";
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              data: response.data ?? [],
            ),
          );
        }
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: response.message,
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

  sendOtp(PatientTransactionModel model) async {
    _log.d("sendOtp called");
    safeEmit(
      state.copyWith(
        status2: EnumGeneralStateStatus.loading,
        selectedModel: model,
      ),
    );
    try {
      final response = await service.postRefundSendOtp();
      if (response.success == true &&
          response.data is RefundSendOtpResponseModel) {
        safeEmit(
          state.copyWith(
            status2: EnumGeneralStateStatus.success,
            encriptedData: response.data?.encryptedOtp,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            status2: EnumGeneralStateStatus.failure,
            message: response.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status2: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status2: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  otpVerify(String code) async {
    _log.d("otpVerify called");
    safeEmit(state.copyWith(status2: EnumGeneralStateStatus.loading));
    try {
      final response = await service.postRefundOtpVerify(
        RefundOtpVerifyRequestModel(
          encryptedOtp: state.encriptedData,
          code: code,
        ),
      );
      if (response.success == true &&
          response.data is RefundOtpVerifyResponseModel) {
        safeEmit(
          state.copyWith(
            status2: EnumGeneralStateStatus.success,
            encriptedData: response.data?.encryptedOtp,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            status2: EnumGeneralStateStatus.failure,
            message: response.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status2: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status2: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  clearStatus2() {
    _log.d("clearstatus2 called");
    safeEmit(state.copyWith(status2: EnumGeneralStateStatus.initial));
  }
}
