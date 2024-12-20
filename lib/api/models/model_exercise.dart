import 'dart:convert';

class ModelTrainingPlan {
  final String goal;
  final String fitnessLevel;
  final int totalWeeks;
  final ModelSchedule schedule;
  final List<ModelExerciseDay> exercises;
  final String seoTitle;
  final String seoContent;
  final String seoKeywords;
  final DateTime startDate;
  final DateTime endDate;

  ModelTrainingPlan({
    required this.goal,
    required this.fitnessLevel,
    required this.totalWeeks,
    required this.schedule,
    required this.exercises,
    required this.seoTitle,
    required this.seoContent,
    required this.seoKeywords,
    required this.startDate,
    required this.endDate,
  });

  factory ModelTrainingPlan.fromJson(Map<String, dynamic> json) {
    json = json['result'];
    return ModelTrainingPlan(
      goal: utf8.decode(json['goal'].toString().codeUnits),
      fitnessLevel: utf8.decode(json['fitness_level'].toString().codeUnits),
      totalWeeks: json['total_weeks'],
      schedule: ModelSchedule.fromJson(json['schedule']),
      exercises: (json['exercises'] as List)
          .map((item) => ModelExerciseDay.fromJson(item))
          .toList(),
      seoTitle: utf8.decode(json['seo_title'].toString().codeUnits),
      seoContent: utf8.decode(json['seo_content'].toString().codeUnits),
      seoKeywords: utf8.decode(json['seo_keywords'].toString().codeUnits),
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
    );
  }

  factory ModelTrainingPlan.fromCreateJson(Map<String, dynamic> json) {
    return ModelTrainingPlan(
      goal: utf8.decode(json['goal'].toString().codeUnits),
      fitnessLevel: utf8.decode(json['fitness_level'].toString().codeUnits),
      totalWeeks: json['total_weeks'],
      schedule: ModelSchedule.fromJson(json['schedule']),
      exercises: (json['exercises'] as List)
          .map((item) => ModelExerciseDay.fromJson(item))
          .toList(),
      seoTitle: utf8.decode(json['seo_title'].toString().codeUnits),
      seoContent: utf8.decode(json['seo_content'].toString().codeUnits),
      seoKeywords: utf8.decode(json['seo_keywords'].toString().codeUnits),
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now().add(const Duration(days: 7)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'fitness_level': fitnessLevel,
      'total_weeks': totalWeeks,
      'schedule': schedule.toJson(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'seo_title': seoTitle,
      'seo_content': seoContent,
      'seo_keywords': seoKeywords,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'goal': goal,
      'fitness_level': fitnessLevel,
      'total_weeks': totalWeeks,
      'schedule': schedule.toJson(),
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'seo_title': seoTitle,
      'seo_content': seoContent,
      'seo_keywords': seoKeywords,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}

class ModelSchedule {
  final int daysPerWeek;
  final int sessionDuration;

  ModelSchedule({
    required this.daysPerWeek,
    required this.sessionDuration,
  });

  factory ModelSchedule.fromJson(Map<String, dynamic> json) {
    return ModelSchedule(
      daysPerWeek: json['days_per_week'],
      sessionDuration: json['session_duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days_per_week': daysPerWeek,
      'session_duration': sessionDuration,
    };
  }
}

class ModelExerciseDay {
  final String day;
  final List<ModelExercise> exercises;

  ModelExerciseDay({
    required this.day,
    required this.exercises,
  });

  factory ModelExerciseDay.fromJson(Map<String, dynamic> json) {
    return ModelExerciseDay(
      day: utf8.decode(json['day'].toString().codeUnits),
      exercises: (json['exercises'] as List)
          .map((item) => ModelExercise.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class ModelExercise {
  final String name;
  final String duration;
  final String? repetitions; // Permite valores nulos
  final String? sets; // Permite valores nulos
  final String equipment;

  ModelExercise({
    required this.name,
    required this.duration,
    this.repetitions, // Agora pode ser nulo
    this.sets, // Agora pode ser nulo
    required this.equipment,
  });

  factory ModelExercise.fromJson(Map<String, dynamic> json) {
    return ModelExercise(
      name: utf8.decode(json['name'].toString().codeUnits),
      duration: utf8.decode(json['duration'].toString().codeUnits),
      repetitions: json['repetitions'] != null
          ? utf8.decode(json['repetitions'].toString().codeUnits)
          : '', // Se for nulo, atribui uma string vazia
      sets: json['sets'] != null
          ? utf8.decode(json['sets'].toString().codeUnits)
          : '', // Se for nulo, atribui uma string vazia
      equipment: utf8.decode(json['equipment'].toString().codeUnits),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'repetitions': repetitions ?? '',
      'sets': sets ?? '',
      'equipment': equipment,
    };
  }
}
