import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toko_online_sederhana/core/router/router.dart';
import 'package:toko_online_sederhana/core/services/alarm_service.dart';
import 'package:toko_online_sederhana/core/services/notification_service.dart';
import 'package:toko_online_sederhana/core/theme/app_theme.dart';

import 'core/constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await _requestNotificationPermission();
  } catch (e) {
    debugPrint('⚠️ Error requesting notification permission: $e');
  }

  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('⚠️ Error initializing NotificationService: $e');
  }

  try {
    await AlarmService().initialize();
  } catch (e) {
    debugPrint('⚠️ Error initializing AlarmService: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _requestNotificationPermission() async {
  try {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      debugPrint('📱 Requesting notification permission...');
      final result = await Permission.notification.request();

      if (result.isGranted) {
        debugPrint('✅ Notification permission granted');
      } else if (result.isDenied) {
        debugPrint('❌ Notification permission denied');
      } else if (result.isPermanentlyDenied) {
        debugPrint('⚠️ Notification permission permanently denied');
      }
    } else if (status.isGranted) {
      debugPrint('✅ Notification permission already granted');
    }
  } catch (e) {
    debugPrint('⚠️ Permission handler error: $e');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme(context, lightDynamic),
          darkTheme: AppTheme.darkTheme(context, darkDynamic),
          themeMode: ThemeMode.system,

          routerConfig: goRouter,
        );
      },
    );
  }
}
