import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projeto/api/api_manager.dart';
import 'package:projeto/colors.dart';
import 'package:projeto/extensions.dart';
import 'package:projeto/router.gr.dart';

typedef RouteBuilder = PageRouteInfo Function();
typedef PageData = ({
  List<String> allowedRoles,
  String label,
  RouteBuilder routeBuilder,
  Widget icon,
  Widget selectedIcon
});

@RoutePage()
class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  static final List<PageData> _pages = [
    (
      allowedRoles: ['admin', 'user'],
      label: 'Home',
      routeBuilder: () => const HomeRoute(),
      icon: const Icon(Icons.home, color: grey),
      selectedIcon: const Icon(
        Icons.home,
        color: orange,
      )
    ),
    (
      allowedRoles: ['admin', 'user'],
      label: 'Exercícios',
      routeBuilder: () => const ExercisesRoute(),
      icon: const Icon(Icons.fitness_center, color: grey),
      selectedIcon: const Icon(Icons.fitness_center, color: orange),
    ),
    (
      allowedRoles: ['admin'],
      label: 'Usuários',
      routeBuilder: () => const UsersRoute(),
      icon: const Icon(Icons.people, color: grey),
      selectedIcon: const Icon(Icons.people, color: orange),
    ),
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late String userRole;
  late List<PageData> _allowedPages;

  @override
  void initState() {
    super.initState();
    String? userRole = Hive.box('userData').get('role');
    if (userRole == null) {
      context.router.replace(const LoginRoute());
    } else {
      _allowedPages =
          _pages.where((page) => page.allowedRoles.contains(userRole)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: _allowedPages.map((page) => page.routeBuilder()).toList(),
      animatePageTransition: true,
      physics: const NeverScrollableScrollPhysics(),
      builder: (context, child, c) {
        ApiManager().navigationContext = context;
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          backgroundColor: beige,
          key: _key,
          body: Row(
            children: [
              Theme(
                data: ThemeData(
                  colorScheme:
                      const ColorScheme.light(primary: Colors.transparent),
                  highlightColor: Colors.transparent,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(
                            4, 0), // deslocamento horizontal da sombra
                        blurRadius: 8, // intensidade do desfoque
                      ),
                    ],
                  ),
                  child: NavigationRail(
                    groupAlignment: 0.0,
                    useIndicator: false,
                    minWidth: 224,
                    leading: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 224,
                        minWidth: 224,
                      ),
                      child: const Image(
                        image: AssetImage("images/nutrimove_logo.png"),
                        fit: BoxFit.scaleDown,
                      ),
                    ).withPadding(const EdgeInsets.only(top: 64)),
                    backgroundColor: Colors.white,
                    selectedIndex: tabsRouter.activeIndex,
                    onDestinationSelected: (index) {
                      tabsRouter.setActiveIndex(index);
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: _allowedPages.map((page) {
                      final index = _allowedPages.indexOf(page);
                      return NavigationRailDestination(
                        icon: InkWell(
                          onTap: () {
                            tabsRouter.setActiveIndex(index);
                          },
                          splashColor: orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 192,
                              minHeight: 47,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 16),
                                page.icon,
                                const SizedBox(width: 8),
                                Text(
                                  page.label,
                                  style: const TextStyle(color: grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        selectedIcon: InkWell(
                          onTap: () {
                            tabsRouter.setActiveIndex(index);
                          },
                          splashColor: orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 192,
                              minHeight: 47,
                            ),
                            decoration: BoxDecoration(
                              color: green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 16),
                                page.selectedIcon,
                                const SizedBox(width: 8),
                                Text(
                                  page.label,
                                  style: TextStyle(
                                    color: tabsRouter.activeIndex == index
                                        ? orange
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        label: const Text(''),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
