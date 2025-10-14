import 'package:flutter/material.dart';

import '../app.dart';

extension RouterX on BuildContext {
  AppRouterDelegate get appRouter => Router.of(this).routerDelegate as AppRouterDelegate;
}
