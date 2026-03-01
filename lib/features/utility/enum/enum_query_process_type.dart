enum EnumQueryProcessType {
  appointmentWithTransaction,
  appointment,
  transaction;

  static EnumQueryProcessType? fromString(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'appointmentWithTransaction':
        return EnumQueryProcessType.appointmentWithTransaction;
      case 'appointment':
        return EnumQueryProcessType.appointment;
      case 'transaction':
        return EnumQueryProcessType.transaction;
      default:
        return null;
    }
  }

  String toValue() {
    switch (this) {
      case EnumQueryProcessType.appointmentWithTransaction:
        return 'appointmentWithTransaction';
      case EnumQueryProcessType.appointment:
        return 'appointment';
      case EnumQueryProcessType.transaction:
        return 'transaction';
    }
  }
}
