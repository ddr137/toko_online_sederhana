import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toko_online_sederhana/core/router/router.dart';
import 'package:toko_online_sederhana/core/services/alarm_service.dart';
import 'package:toko_online_sederhana/core/services/notification_service.dart';

import 'core/constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestNotificationPermission();

  await NotificationService().initialize();
  await AlarmService().initialize();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied) {
    print('📱 Requesting notification permission...');
    final result = await Permission.notification.request();

    if (result.isGranted) {
      print('✅ Notification permission granted');
    } else if (result.isDenied) {
      print('❌ Notification permission denied');
    } else if (result.isPermanentlyDenied) {
      print('⚠️ Notification permission permanently denied');
    }
  } else if (status.isGranted) {
    print('✅ Notification permission already granted');
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
