import 'package:flutter/material.dart';

class AppRouter {
  const AppRouter._();

  static PageRouteBuilder<dynamic> animated(
    RouteSettings settings,
    WidgetBuilder builder, {
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      fullscreenDialog: fullscreenDialog,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final tween = Tween<Offset>(
          begin: Offset(isRtl ? -0.04 : 0.04, 0),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: tween.animate(curved), child: child),
        );
      },
    );
  }
}
