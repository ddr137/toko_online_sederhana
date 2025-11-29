import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'order_channel',
      'Order Notifications',
      description: 'Notifications for order status updates',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showOrderCancelledNotification(
    String orderId,
    String customerName,
  ) async {
    print('🔔 Attempting to send notification for Order #$orderId');

    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Notifications for order status updates',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await _notifications.show(
        orderId.hashCode,
        '⏰ Pesanan Kadaluarsa - Order #$orderId',
        'Pesanan atas nama $customerName telah kadaluarsa (>24 jam tanpa pembayaran) dan otomatis dibatalkan oleh sistem.',
        notificationDetails,
      );
      print('✅ Notification sent successfully for Order #$orderId');
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  Future<void> showTestNotification() async {
    print('🧪 Sending test notification...');

    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Test notification',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await _notifications.show(
        999,
        'Test Notification',
        'Ini adalah test notification dari sistem auto-cancel',
        notificationDetails,
      );
      print('✅ Test notification sent');
    } catch (e) {
      print('❌ Test notification failed: $e');
    }
  }

  void _onNotificationTap(NotificationResponse response) {}
}
