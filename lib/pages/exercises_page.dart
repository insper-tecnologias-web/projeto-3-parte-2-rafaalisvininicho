import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projeto/widgets/pad_scaffold.dart';

@RoutePage()
class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PadScaffold(
      child: Placeholder(
        color: Colors.green,
      ),
    );
  }
}
