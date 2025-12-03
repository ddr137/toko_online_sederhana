import 'dart:io' show Platform;

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';
import 'package:toko_online_sederhana/core/services/notification_service.dart';
import 'package:toko_online_sederhana/features/order/data/datasources/order_local_datasource.dart';
import 'package:toko_online_sederhana/features/order/data/repositories/order_repository.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  static const int _alarmId = 0;

  Future<void> initialize() async {
    // Only initialize on Android
    if (!kIsWeb && Platform.isAndroid) {
      try {
        await AndroidAlarmManager.initialize();
        await schedulePeriodicCheck();
        debugPrint('✅ AlarmService initialized on Android');
      } catch (e) {
        debugPrint('⚠️ Error initializing AlarmService: $e');
      }
    } else {
      debugPrint('ℹ️ AlarmService skipped (not Android)');
    }
  }

  Future<void> schedulePeriodicCheck() async {
    // Only run on Android
    if (!kIsWeb && Platform.isAndroid) {
      await AndroidAlarmManager.periodic(
        const Duration(hours: 1),
        _alarmId,
        _checkExpiredOrders,
        wakeup: true,
        rescheduleOnReboot: true,
        exact: false,
        allowWhileIdle: true,
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _checkExpiredOrders() async {
    final database = AppDatabase();
    final datasource = OrderLocalDataSourceImpl(
      database.orderDao,
      database.orderItemDao,
    );
    final repository = OrderRepositoryImpl(datasource);

    final cancelledOrders = await repository.checkAndCancelExpiredOrders();

    if (cancelledOrders.isNotEmpty) {
      final notificationService = NotificationService();
      await notificationService.initialize();

      for (final order in cancelledOrders) {
        await notificationService.showOrderCancelledNotification(
          order.id.toString(),
          order.customerName,
        );
      }
    }
  }

  Future<void> triggerManualCheck({Duration? threshold}) async {
    final database = AppDatabase();
    final datasource = OrderLocalDataSourceImpl(
      database.orderDao,
      database.orderItemDao,
    );
    final repository = OrderRepositoryImpl(datasource);

    final cancelledOrders = await repository.checkAndCancelExpiredOrders(
      threshold: threshold ?? const Duration(hours: 24),
    );

    print('🔍 Found ${cancelledOrders.length} expired orders to cancel');

    if (cancelledOrders.isNotEmpty) {
      final notificationService = NotificationService();
      await notificationService.initialize();
      print('✅ NotificationService initialized');

      for (final order in cancelledOrders) {
        print('📦 Processing order #${order.id} - ${order.customerName}');
        await notificationService.showOrderCancelledNotification(
          order.id.toString(),
          order.customerName,
        );
      }
    } else {
      print('ℹ️ No expired orders found');
    }
  }
}
