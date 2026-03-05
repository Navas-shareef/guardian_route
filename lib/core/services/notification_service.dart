import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'tracking_channel',
    'Tracking Service',
    description: 'Location tracking notification',
    importance: Importance.low,
  );

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        if (details.actionId == "STOP_TRACKING") {
          FlutterLocalNotificationsPlugin()
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.cancel(id: 1);
        }
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  @pragma('vm:entry-point')
  static Future<void> updateTrackingNotification(
    double lat,
    double lng, {
    bool isFirstNotification = false,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'tracking_channel',
      'Tracking Service',
      channelDescription: 'Location tracking notification',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      actions: [AndroidNotificationAction('STOP_TRACKING', 'Stop Tracking')],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id: 1,
      title: "Guardian Route Tracking",
      body: isFirstNotification
          ? 'Location Fetching Enabled'
          : "Lat: $lat , Lng: $lng",
      notificationDetails: notificationDetails,
    );
  }
}
