part of './../api_manager.dart';

extension ExercisesApi on ApiManager {
  Future<ModelTrainingPlan> generateCustomTrainWeek(
      String goal,
      String fitnessLevel,
      String healthConditionsString,
      String preferencesString,
      int daysPerWeek,
      int sessionDuration,
      int planDurationWeeks,
      String customGoalsString) async {
    final List<String> customGoals = customGoalsString.split(',');
    final List<String> healthConditions = healthConditionsString.split(',');
    final List<String> preferences = preferencesString.split(',');
    print(daysPerWeek);
    print(sessionDuration);
    print(planDurationWeeks);
    print(customGoals);
    print(healthConditions);
    print(preferences);
    print(fitnessLevel);
    print(goal);
    try {
      final response = await post('exercises/custom/', {
        'goal': goal,
        'fitness_level': fitnessLevel,
        'health_conditions': healthConditions,
        'preferences': preferences,
        'schedule': {
          'days_per_week': daysPerWeek,
          'session_duration': sessionDuration,
        },
        'plan_duration_weeks': planDurationWeeks,
        'custom_goals': customGoals,
      });
      final ModelTrainingPlan trainingPlan =
          ModelTrainingPlan.fromJson(response);
      return trainingPlan;
    } catch (error) {
      throw Exception('Erro ao gerar treino: $error');
    }
  }

  Future<ModelTrainingPlan?> getWeekTrainingPlan(
      DateTime startDate, DateTime endDate) async {
        print("Olá");
    try {
      final response = await post(
        'exercises/week/',
        {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'user_id': Hive.box('userData').get('id'),
        },
      );
      return ModelTrainingPlan.fromJson(response);
    } catch (error) {
      if (error.toString().contains("No training plan found")) {
        return null;
      }
      throw Exception('Erro ao buscar treino: $error');
    }
  }

  Future<void> saveTrainingPlan(trainingPlan) async {
    try {
      await post('exercises/save/', trainingPlan);
    } catch (error, stackTrace) {
      print('StackTrace: $stackTrace');
      throw Exception('Erro ao salvar treino: $error');
    }
  }
}
