import 'package:flutter/material.dart';
import 'package:toko_online_sederhana/shared/extensions/logger_ext.dart';


class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    'Current screen: $screenName'.logInfo();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is PageRoute) {
      debugPrint('Route removed: ${route.settings.name}');
    }
  }

  void didInitTabRoute(PageRoute<dynamic> route) {
    debugPrint('Tab route initialized: ${route.settings.name}');
  }
  void didChangeTabRoute(
    PageRoute<dynamic> newRoute,
    PageRoute<dynamic> oldRoute,
  ) {
    debugPrint(
      'Tab route changed from ${oldRoute.settings.name} to ${newRoute.settings.name}',
    );
  }
}

