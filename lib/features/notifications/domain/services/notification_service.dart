abstract class NotificationService {
  Future<void> scheduleMedicationNotification({
    required int id,
    required String title,
    required DateTime dateTime,
  });

  Future<void> cancelNotification(int id);
}
