import 'package:flutter/material.dart';

import '../const/constant_color.dart';
import '../const/constant_string.dart';

enum EnumPaymentResultType {
  success,
  failure;

  String get title {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().paymentSuccess;
      case EnumPaymentResultType.failure:
        return ConstantString().paymentFailure;
    }
  }

  Icon get icon {
    switch (this) {
      case EnumPaymentResultType.success:
        return Icon(Icons.check_circle, color: ConstColor.green, size: 100);
      case EnumPaymentResultType.failure:
        return Icon(Icons.cancel, color: ConstColor.red, size: 100);
    }
  }

  String get description {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().paymentCompletedSuccessfully;
      case EnumPaymentResultType.failure:
        return ConstantString().paymentCompletedFailed;
    }
  }

  String get message {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().examinationRegistrationCreated;
      case EnumPaymentResultType.failure:
        return ConstantString().requirePaymentForExaminationRegistration;
    }
  }
}
