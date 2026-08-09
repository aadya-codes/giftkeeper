import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/person.dart' as model;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  // This was missing entirely before — with no iOS settings, the plugin's
  // iOS side is never set up and permission is never requested, which
  // made scheduling calls throw on iPhone (this in turn broke editing:
  // person_details_screen awaits these calls before it pops back, so a
  // throw here silently stuck the user on the same screen).
  const iOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const settings = InitializationSettings(
    android: android,
    iOS: iOS,
  );

  await notifications.initialize(settings);

  tz.initializeTimeZones();

  final String currentTimeZone =
      await FlutterTimezone.getLocalTimezone();

  tz.setLocalLocation(
    tz.getLocation(currentTimeZone),
  );

  await notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

  static Future<void> scheduleBirthdayNotification({
    required int id,
    required String name,
    required DateTime birthday,
  }) async {
    DateTime scheduled = DateTime(
      DateTime.now().year,
      birthday.month,
      birthday.day,
      9,
      0,
    );

  if (scheduled.isBefore(DateTime.now())) {
    scheduled = DateTime(
      DateTime.now().year + 1,
      birthday.month,
      birthday.day,
      9,
      0,
    );
  }

  await notifications.zonedSchedule(
    id,
    "🎂 Birthday Reminder",
    "Today is $name's birthday!",
    tz.TZDateTime.from(scheduled, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "birthday_channel",
        "Birthdays",
        channelDescription: "Birthday reminders",
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );
  }

  static tz.TZDateTime _nextInstance(
  int month,
  int day,
  int hour,
  int minute,
) {
  final now = tz.TZDateTime.now(tz.local);

  var scheduled = tz.TZDateTime(
    tz.local,
    now.year,
    month,
    day,
    hour,
    minute,
  );

  if (scheduled.isBefore(now)) {
    scheduled = tz.TZDateTime(
      tz.local,
      now.year + 1,
      month,
      day,
      hour,
      minute,
    );
  }

  return scheduled;
  }

  static Future<void> scheduleBirthdayNotifications(
  model.Person person,
) async {
  final birthday = _nextInstance(
    person.month,
    person.day,
    9,
    0,
  );

  final oneWeekBefore = birthday.subtract(
    const Duration(days: 7),
  );

  final oneDayBefore = birthday.subtract(
    const Duration(days: 1),
  );

  await notifications.zonedSchedule(
    person.hashCode + 1,
    "🎁 Birthday in one week",
    "${person.name}'s birthday is next week! Time to find the perfect gift.",
    oneWeekBefore,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "birthdays",
        "Birthdays",
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );

  await notifications.zonedSchedule(
    person.hashCode + 2,
    "🎈 Birthday tomorrow",
    "Don't forget ${person.name}'s birthday tomorrow!",
    oneDayBefore,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "birthdays",
        "Birthdays",
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );

  await notifications.zonedSchedule(
    person.hashCode + 3,
    "🎉 Birthday Today!",
    "Wish ${person.name} a happy birthday today!",
    birthday,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        "birthdays",
        "Birthdays",
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );
  }

  static Future<void> cancelBirthdayNotifications(
  model.Person person,
) async {
  await notifications.cancel(person.hashCode + 1);
  await notifications.cancel(person.hashCode + 2);
  await notifications.cancel(person.hashCode + 3);
}

}