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
              CustomRoute(
                  page: HealthyMenuRoute.page,
                  path: 'healthymenu',
                  guards: [AuthGuard()]),
              CustomRoute(
                  page: UsersRoute.page,
                  path: 'admin/users',
                  guards: [AuthGuard(), AdminGuard()])
            ]),
        CustomRoute(page: LoginRoute.page, path: '/login'),
        CustomRoute(page: SignUpRoute.page, path: '/signup'),
      ];
}
