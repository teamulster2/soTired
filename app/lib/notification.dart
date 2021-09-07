import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Show a notification
  /// The *[minutesTimer]* is the time in minutes when the push notification will be delivered.
  /// The *[headLine]* will be showed on top in the push notification.
  /// The *[body]* is the main msg. do you will send.
  Future<void> showScheduleNotification(
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
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'id', 'channel ', 'description',
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
  Future<void> showPeriodicNotification(RepeatInterval interval) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'channel_id', 'Channel Name', 'Channel Description');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await notificationsPlugin.periodicallyShow(
        0,
        "soTired", //TODO: load from config
        "It's time to play with me, you tired warrior.",
        //TODO: load from config
        interval,
        notificationDetails,
        payload: 'Destination Screen(Periodic Notification)');
  }

  ///initializing the setting for Android.
  initializeSetting() async {
    const AndroidInitializationSettings initializeAndroid = AndroidInitializationSettings('logo');//TODO: add a real logo
    const InitializationSettings initializeSetting = InitializationSettings(android: initializeAndroid);
    await notificationsPlugin.initialize(initializeSetting);
  }
}
