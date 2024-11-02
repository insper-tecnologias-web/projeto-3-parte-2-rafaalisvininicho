import 'package:auto_route/auto_route.dart';
import 'package:projeto/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(page: LoginRoute.page, path: '/login', initial: true),
      ];
}
