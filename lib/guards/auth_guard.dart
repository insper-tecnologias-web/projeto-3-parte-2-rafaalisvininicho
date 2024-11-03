import 'package:auto_route/auto_route.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projeto/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    print(Hive.box("userData").get("id"));
    if (Hive.box("userData").get("id") == null) {
      resolver.redirect(const LoginRoute());
      return;
    }
    resolver.next(true);
  }
}
