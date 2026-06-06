import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sub_tracker/data/models/subscription.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  
  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    await _plugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ));

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> schedule(Subscription sub) async {
    if (!sub.isActive || sub.deadline == null) return;

    final d = sub.deadline!;
    final when = DateTime(d.year, d.month, d.day - 1, 9);

    if (when.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      int.parse(sub.id),
      '${sub.name} renews tomorrow',
      'Do you still want to keep this subscription? Review before it renews',
      tz.TZDateTime.from(when, tz.local),
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancel(String subId) => _plugin.cancel(int.parse(subId));
  Future<void> cancelAll()          => _plugin.cancelAll();

  
  static const _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'reminders',
      'Deadline reminders',
      importance: Importance.high,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
    ),
    iOS: DarwinNotificationDetails(),
  );
}