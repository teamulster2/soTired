import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tuple/tuple.dart';

class Notifications {
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  tz.TZDateTime _nextTime(int day, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day + day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> showScheduleNotification(String headLine, String body) async {
    int _day = 0;
    final List<Tuple2<int, int>> utcTimes = <Tuple2<int, int>>[
      //ignore: prefer_const_constructors, always_specify_types
      Tuple2(13, 07),
      //ignore: prefer_const_constructors, always_specify_types
      Tuple2(13, 08),
      //ignore: prefer_const_constructors, always_specify_types
      Tuple2(13, 09),
    ];

    while (_day <= 3) {
      //notifications for the next 3 days will be added
      for (int i = 0; i < utcTimes.length; i++) {
        await notificationsPlugin.zonedSchedule(
            i,
            headLine,
            body,
            _nextTime(_day, utcTimes[i].item1, utcTimes[i].item2),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                  'channel id', 'channel name', 'channel description'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }
      _day++;
    }
  }

  /// Show a notification
  /// The *[minutesTimer]* is the time in minutes when the push notification will be delivered.
  /// The *[headLine]* will be showed on top in the push notification.
  /// The *[body]* is the main msg. do you will send.
  Future<void> showTimerNotification(
      int minutesTimer, String headLine, String body) async {
    notificationsPlugin.zonedSchedule(
        0,
        headLine,
        body,
        tz.TZDateTime.now(tz.local).add(Duration(minutes: minutesTimer)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'channel id', 'channel name', 'channel description'),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  /// Show a notification
  /// The *[headLine]* will be showed on top in the push notification.
  /// The *[body]* is the main msg. do you will send.
  showSimpleNotification(String headLine, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('id', 'channel ', 'description',
            priority: Priority.high, importance: Importance.max);
    const IOSNotificationDetails iOSDetails = IOSNotificationDetails();
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await notificationsPlugin.show(0, headLine, body, platformDetails,
        payload: 'Destination Screen (Simple Notification)');
  }

  /// Periodically show a notification using the specified interval.
  /// Give the method a RepeatInterval for example:
  ///
  /// <RepeatInterval.everyMinute>
  ///
  /// The headline and body msg. will be loaded from the config.
  Future<void> showPeriodicNotification(
      RepeatInterval interval, String headLine, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'channel_id', 'Channel Name', 'Channel Description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.periodicallyShow(
        0, headLine, body, interval, notificationDetails,
        payload: 'Destination Screen(Periodic Notification)');
  }

  ///initializing the setting for Android.
  initializeSetting() async {
    const AndroidInitializationSettings initializeAndroid =
        AndroidInitializationSettings('icon');
    const InitializationSettings initializeSetting =
        InitializationSettings(android: initializeAndroid);
    await notificationsPlugin.initialize(initializeSetting);
  }
}
