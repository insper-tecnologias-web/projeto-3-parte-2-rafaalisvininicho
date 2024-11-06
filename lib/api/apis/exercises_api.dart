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

  Future<ModelTrainingPlan> getWeekTrainingPlan(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await post(
        'exercises/week/',
        {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );
      final ModelTrainingPlan trainingPlan =
          ModelTrainingPlan.fromJson(response);
      return trainingPlan;
    } catch (error) {
      throw Exception('Erro ao buscar treino: $error');
    }
  }

  Future<void> saveTrainingPlan(ModelTrainingPlan trainingPlan) async {
    print(trainingPlan.toCreateJson());
    try {
      await post('exercises/save/', trainingPlan.toCreateJson());
    } catch (error) {
      throw Exception('Erro ao salvar treino: $error');
    }
  }
}
