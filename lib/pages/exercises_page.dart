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
      body: FutureBuilder(
          future: dataTrainingPlan ??= ApiManager().generateCustomTrainWeek(
              "Emagrecer",
              "Difícil",
              "Dor na panturrilha, Dor no pulso",
              "Yoga",
              3,
              60,
              2,
              "Perder peso"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              final data = snapshot.data as ModelTrainingPlan;
              return Column(
                children: [
                  Text(data.fitnessLevel),
                  Text(data.goal),
                  Text(data.schedule.daysPerWeek.toString()),
                  Text(data.seoTitle),
                  for (final exercise in data.exercises)
                    Text(exercise.exercises.first.name),
                ],
              );
            }
          }),
    );
  }
}
