import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projeto/widgets/pad_scaffold.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PadScaffold(child: Placeholder());
  }
}
