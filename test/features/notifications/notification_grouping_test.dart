import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pills_reminder/core/models/custom_hive_adapters.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/notifications/data/repositories/notification_repo_impl.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockNotificationDetails extends Mock implements NotificationDetails {}

class MockBox extends Mock implements Box {}

void main() {
  late MockFlutterLocalNotificationsPlugin mockPlugin;
  late Directory tempDir;
  late NotificationRepoImpl notificationRepo;
  late NotificationsController notificationsController;
  late SettingsController settingsController;

  setUpAll(() async {
    registerFallbackValue(NotificationDetails());
    // Initialize timezone for fallback value creation
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));
    registerFallbackValue(tz.TZDateTime.now(tz.local));
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
    registerFallbackValue(DateTimeComponents.time);

    // Setup Hive
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    // Register Adapters
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(NotificationListAdapter());
    }
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(DateTimeComponentsAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(AndroidScheduleModeAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(WeekdayAdapter());
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(TZDateTimeAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(NotificationTypeAdapter());
    }
  });

  setUp(() async {
    // Clear Hive boxes
    await Hive.deleteBoxFromDisk('notifications');
    await Hive.deleteBoxFromDisk('groupedNotifications');
    await Hive.deleteBoxFromDisk('Settings');

    // Setup Timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));

    // Mocks
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    when(
      () => mockPlugin.zonedSchedule(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        scheduledDate: any(named: 'scheduledDate'),
        notificationDetails: any(named: 'notificationDetails'),
        matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});

    when(() => mockPlugin.cancel(id: any(named: 'id'))).thenAnswer((_) async {});
    when(() => mockPlugin.cancelAll()).thenAnswer((_) async {});
    when(
      () => mockPlugin.pendingNotificationRequests(),
    ).thenAnswer((_) async => []);

    // Controllers
    Get.testMode = true;

    // Mock Settings Box
    final settingsBox = await Hive.openBox('Settings');
    settingsController = Get.put(SettingsController(settingsBox));

    // Use TestNotificationRepoImpl to inject mock plugin
    notificationRepo = TestNotificationRepoImpl(mockPlugin);

    notificationsController = Get.put(
      NotificationsController(notificationRepo),
    );
  });

  tearDown(() async {
    Get.reset();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('Schedule individual notifications (Normal Mode)', () async {
    // Arrange
    settingsController.groupedNotifications.value = false;
    final time = DateTime.utc(2026, 1, 1, 12, 0);

    // Act
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 1,
      medicationName: 'Med A',
      isRepeating: true,
    );

    // Assert
    final box = await Hive.openBox<NotificationList>('notifications');
    expect(box.get(1), isNotNull);
    expect(box.get(1)!.items.length, 1);
    expect(box.get(1)!.items.first.title, contains('Med A'));
  });

  test('Schedule grouped notifications (Grouped Mode)', () async {
    // Arrange
    settingsController.groupedNotifications.value = true;
    final time = DateTime.utc(2026, 1, 1, 12, 0); // 12:00

    // Act
    // Schedule Med A
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 1,
      medicationName: 'Med A',
      isRepeating: true,
    );

    // Schedule Med B at same time
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 2,
      medicationName: 'Med B',
      isRepeating: true,
    );

    // Assert
    final box = await Hive.openBox('groupedNotifications');
    // Key for 12:00 is 'M1/12:0' because scheduleNotification uses dayOfMonthAndTime
    final key = 'M1/12:0';
    final NotificationModel? notification = box.get(key);

    expect(notification, isNotNull);
    expect(notification!.title, contains('Med A'));
    expect(notification.title, contains('Med B'));
    expect(notification.payload, contains('"id":"1, 2"'));
    expect(notification.payload, contains('"is Grouped":"true"'));
  });

  test('Switch from Normal to Grouped Mode', () async {
    // Arrange
    settingsController.groupedNotifications.value = false;
    final time = DateTime.utc(2026, 1, 1, 12, 0);

    // Schedule Med A and Med B separately
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 1,
      medicationName: 'Med A',
      isRepeating: true,
    );
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 2,
      medicationName: 'Med B',
      isRepeating: true,
    );

    // Act
    await settingsController.changeNotificationMode(true);

    // Assert
    final groupedBox = await Hive.openBox('groupedNotifications');
    final normalBox = await Hive.openBox<NotificationList>('notifications');

    expect(normalBox.isEmpty, true);
    expect(groupedBox.isNotEmpty, true);

    final key = 'M1/12:0';
    final NotificationModel? notification = groupedBox.get(key);
    expect(notification, isNotNull);
    expect(notification!.title, contains('Med A'));
    expect(notification.title, contains('Med B'));
  });

  test('Switch from Grouped to Normal Mode', () async {
    // Arrange
    settingsController.groupedNotifications.value = true;
    final time = DateTime.utc(2026, 1, 1, 12, 0);

    // Schedule Med A and Med B (grouped)
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 1,
      medicationName: 'Med A',
      isRepeating: true,
    );
    await notificationsController.scheduleNotification(
      dateTime: time,
      id: 2,
      medicationName: 'Med B',
      isRepeating: true,
    );

    // Act
    await settingsController.changeNotificationMode(false);

    // Assert
    final groupedBox = await Hive.openBox('groupedNotifications');
    final normalBox = await Hive.openBox<NotificationList>('notifications');

    expect(groupedBox.isEmpty, true);
    expect(normalBox.isNotEmpty, true);

    final list1 = normalBox.get(1);
    final list2 = normalBox.get(2);

    expect(list1, isNotNull);
    expect(list1!.items.first.title, contains('Med A'));
    expect(list1.items.first.title, isNot(contains('Med B')));

    expect(list2, isNotNull);
    expect(list2!.items.first.title, contains('Med B'));
    expect(list2.items.first.title, isNot(contains('Med A')));
  });

  test('Multiple times notifications', () async {
    // Arrange
    settingsController.groupedNotifications.value = true;
    final time1 = DateTime.utc(2026, 1, 1, 9, 0); // 9:00
    final time2 = DateTime.utc(2026, 1, 1, 20, 0); // 20:00

    // Act
    // Med A at 9:00 and 20:00
    await notificationsController.scheduleNotification(
      dateTime: time1,
      id: 1,
      medicationName: 'Med A',
      isRepeating: true,
    );
    await notificationsController.scheduleNotification(
      dateTime: time2,
      id: 1, // Same medication ID, different time
      medicationName: 'Med A',
      isRepeating: true,
    );

    // Med B at 9:00
    await notificationsController.scheduleNotification(
      dateTime: time1,
      id: 2,
      medicationName: 'Med B',
      isRepeating: true,
    );

    // Assert
    final box = await Hive.openBox('groupedNotifications');

    // 9:00 should have Med A and Med B
    final key1 = 'M1/9:0';
    final notif1 = box.get(key1);
    expect(notif1, isNotNull);
    expect(notif1!.title, contains('Med A'));
    expect(notif1.title, contains('Med B'));

    // 20:00 should have only Med A
    final key2 = 'M1/20:0';
    final notif2 = box.get(key2);
    expect(notif2, isNotNull);
    expect(notif2!.title, contains('Med A'));
    expect(notif2.title, isNot(contains('Med B')));
  });
}

class TestNotificationRepoImpl extends NotificationRepoImpl {
  final FlutterLocalNotificationsPlugin mockPlugin;

  TestNotificationRepoImpl(this.mockPlugin);

  @override
  Future<void> initNotificationService() async {
    // Bypass NotificationManager.initPlugin and use mock
    notificationsPlugin = mockPlugin;
    notificationService = NotificationServiceImpl(mockPlugin);
  }

  @override
  void showSnackBar(String title, String message) {
    // Do nothing in tests
  }
}
