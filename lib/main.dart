import 'package:flutter/material.dart';
import 'package:projeto/colors.dart';
import 'package:projeto/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: const Color(0xFF0D2035),
            backgroundColor: orange,
            elevation: 0,
            fixedSize: const Size(384.0, 40.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: orange,
            ),
          ),
          labelStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: const Color(0xff696969)),
          floatingLabelStyle: const TextStyle(color: green),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: green),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
        ),
      ),
    );
  }
}
