import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projeto/api/api_manager.dart';
import 'package:projeto/api/models/model_exercise.dart';
import 'package:projeto/widgets/pad_scaffold.dart';

@RoutePage()
class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  Future<ModelTrainingPlan>? dataTrainingPlan;
  @override
  Widget build(BuildContext context) {
    return PadScaffold(
      body: Center(child: Text("fudeeeeeu")),
    );
  }
}
