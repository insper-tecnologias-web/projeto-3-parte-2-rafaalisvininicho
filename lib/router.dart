import 'package:auto_route/auto_route.dart';
import 'package:projeto/guards/auth_guard.dart';
import 'package:projeto/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
            page: NavigationBarRoute.page,
            path: '/plataforma',
            initial: true,
            guards: [
              AuthGuard()
            ],
            children: [
              CustomRoute(
                  page: HomeRoute.page,
                  path: 'home',
                  initial: true,
                  guards: [AuthGuard()]),
              CustomRoute(
                  page: ExercisesRoute.page,
                  path: 'exercises',
                  guards: [AuthGuard()]),
            ]),
        CustomRoute(page: LoginRoute.page, path: '/login'),
      ];
}
