import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showNotification() async {
  final now = DateTime.now();

  //if (now.weekday == DateTime.saturday && now.hour == 19) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      priority: Priority.high,
      importance: Importance.max,
    );
    const iOS = IOSNotificationDetails();
    const platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      0,
      '¡Es sábado!',
      'Recuerda disfrutar tu fin de semana.',
      platform,
    );
  }
//}
