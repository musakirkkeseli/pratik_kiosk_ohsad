class TimeoutCancelContextSnapshot {
  final bool isPriceStep;
  final String? patientId;
  final DateTime updatedAt;

  const TimeoutCancelContextSnapshot({
    required this.isPriceStep,
    required this.patientId,
    required this.updatedAt,
  });

  bool get canCancelOnTimeout =>
      isPriceStep && patientId != null && patientId!.isNotEmpty;
}

class TimeoutCancelContextService {
  static TimeoutCancelContextService? _instance;

  TimeoutCancelContextSnapshot? _snapshot;

  factory TimeoutCancelContextService() {
    return _instance ??= TimeoutCancelContextService._internal();
  }

  TimeoutCancelContextService._internal();

  TimeoutCancelContextSnapshot? get snapshot => _snapshot;

  void update({required bool isPriceStep, required String? patientId}) {
    _snapshot = TimeoutCancelContextSnapshot(
      isPriceStep: isPriceStep,
      patientId: patientId,
      updatedAt: DateTime.now(),
    );
  }

  void clear() {
    _snapshot = null;
  }
}
