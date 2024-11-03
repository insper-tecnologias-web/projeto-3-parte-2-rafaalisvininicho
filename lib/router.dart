import 'package:auto_route/auto_route.dart';
import 'package:projeto/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
            page: NavigationBarRoute.page,
            path: '/plataforma',
            initial: true,
            children: [
              CustomRoute(page: HomeRoute.page, path: 'home', initial: true),
              CustomRoute(page: ExercisesRoute.page, path: 'exercises'),
            ]),
        CustomRoute(page: LoginRoute.page, path: '/login'),
      ];
}
