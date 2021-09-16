import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:so_tired/exceptions/exceptions.dart';
import 'package:timezone/timezone.dart';

class Notifications {
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TZDateTime _nextTime(int day, int hour, int minute) {
    final TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduledDate =
        TZDateTime(local, now.year, now.month, now.day + day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Show a notification at a specific time, for the next three days after starting the app.
  /// The *[utcNotificationTimes]* is a list with the specific times when the push notification will be delivered.
  /// Note: The time is given in the UTC format as an tuple.
  /// The *[headLine]* will be showed on top in the push notification.
  /// The *[body]* is the main msg. do you will send.
  Future<void> showScheduleNotification(
      String headLine, String body, List<String> utcNotificationTimes) async {
    int _day = 0;

    while (_day <= 3) {
      //notifications for the next 3 days will be added
      for (final String time in utcNotificationTimes) {
        try {
          _isNotificationTimeValid(time);
          final List<String> splitTime = time.split(':');
          final int hours = int.parse(splitTime[0], radix: 10);
          final int minutes = int.parse(splitTime[1], radix: 10);
          await notificationsPlugin.zonedSchedule(
              utcNotificationTimes.indexOf(time),
              headLine,
              body,
              _nextTime(_day, hours, minutes),
              const NotificationDetails(
                android: AndroidNotificationDetails(
                    'channel id', 'channel name', 'channel description'),
              ),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.time);
        } catch (e) {
          rethrow;
        }
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
        TZDateTime.now(local).add(Duration(minutes: minutesTimer)),
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

  void _isNotificationTimeValid(String time) {
    if (time.length != 5 || !time.contains(':') && !(time.indexOf(':') == 2)) {
      throw NotificationTimeInvalidException(
          'This notification time format is invalid and can not be processed.\n'
          'Current time variable: $time');
    }
  }
}
