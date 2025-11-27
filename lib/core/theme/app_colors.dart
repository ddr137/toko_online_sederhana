import 'package:flutter/material.dart';

class AppColors {

  static Color primary(BuildContext context) => Theme.of(context).colorScheme.primary;
  static Color primaryDark(BuildContext context) => Theme.of(context).colorScheme.primaryContainer;
  static Color primaryLight(BuildContext context) => Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);

  static Color secondary(BuildContext context) => Theme.of(context).colorScheme.secondary;
  static Color secondaryDark(BuildContext context) => Theme.of(context).colorScheme.secondaryContainer;
  static Color secondaryLight(BuildContext context) => Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1);

  static Color success(BuildContext context) => Colors.green;
  static Color warning(BuildContext context) => Colors.orange;
  static Color error(BuildContext context) => Theme.of(context).colorScheme.error;
  static Color info(BuildContext context) => Theme.of(context).colorScheme.primary;

  static Color background(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color surface(BuildContext context) => Theme.of(context).colorScheme.surface;
  static Color onSurface(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color onBackground(BuildContext context) => Theme.of(context).colorScheme.onSurface;

  static Color textPrimary(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color textSecondary(BuildContext context) => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
  static Color textDisabled(BuildContext context) => Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38);

  static Color divider(BuildContext context) => Theme.of(context).dividerColor;
  static Color border(BuildContext context) => Theme.of(context).colorScheme.outline;
}
