abstract class NotificationService {
  Future<void> scheduleMedicationNotification({
    required int id,
    String? title,
    required String body,
    required DateTime dateTime,
  });

  Future<void> normalNotification({
    required String title,
    required String body,
  });

  Future<void> cancelNotification(int id);
}
