import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projeto/api/api_manager.dart';
import 'package:projeto/api/models/model_exercise.dart';
import 'package:projeto/colors.dart';
import 'package:projeto/extensions.dart';
import 'package:projeto/widgets/pad_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:projeto/widgets/show_build_week_train_dialog.dart';
import 'package:projeto/widgets/table_builder.dart';

@RoutePage()
class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  Future<ModelTrainingPlan?>? dataTrainingPlan;
  ExercisesState exercisesState = ExercisesState.withTrain;
  DateTime? startOfWeek;
  DateTime? endOfWeek;
  bool isLoading = false;
  String selectedDay = "Domingo";

  @override
  void initState() {
    super.initState();
    final range = _getCurrentWeekRange();
    startOfWeek = range.$1;
    endOfWeek = range.$2;
  }

  @override
  Widget build(BuildContext context) {
    return PadScaffold(
      title: "Exercícios",
      body: isLoading
          ? const Center(child: CircularProgressIndicator(
            color: orange,
          ))
          : FutureBuilder<ModelTrainingPlan?>(
              future: dataTrainingPlan ??=
                  ApiManager().getWeekTrainingPlan(startOfWeek!, endOfWeek!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: orange,
                  ));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar treino: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final trainingPlan = snapshot.data;
                if (trainingPlan == null || trainingPlan.exercises.isEmpty) {
                  exercisesState = ExercisesState.withoutTrain;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (startOfWeek!.isBefore(DateTime.now())) {
                                  context.warningSnackBar(
                                      "Não é possível voltar no tempo!");
                                  return;
                                }

                                setState(() {
                                  startOfWeek = startOfWeek!
                                      .subtract(const Duration(days: 7));
                                  endOfWeek = endOfWeek!
                                      .subtract(const Duration(days: 7));
                                  dataTrainingPlan = ApiManager()
                                      .getWeekTrainingPlan(
                                          startOfWeek!, endOfWeek!);
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          RichText(
                              text: TextSpan(
                            text: DateFormat('dd/MM').format(startOfWeek!),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            children: [
                              const TextSpan(
                                text: " - ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              TextSpan(
                                text: DateFormat('dd/MM').format(endOfWeek!),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  startOfWeek =
                                      startOfWeek!.add(const Duration(days: 7));
                                  endOfWeek =
                                      endOfWeek!.add(const Duration(days: 7));
                                  dataTrainingPlan = ApiManager()
                                      .getWeekTrainingPlan(
                                          startOfWeek!, endOfWeek!);
                                });
                              },
                              icon: const Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoSlidingSegmentedControl<String>(
                              groupValue: selectedDay,
                              backgroundColor: Colors.white,
                              thumbColor: green,
                              children: const {
                                'Domingo': Text('Dom'),
                                'Segunda-feira': Text('Seg'),
                                'Terça-feira': Text('Ter'),
                                'Quarta-feira': Text('Qua'),
                                'Quinta-feira': Text('Qui'),
                                'Sexta-feira': Text("Sex"),
                                'Sábado': Text("Sáb")
                              },
                              onValueChanged: (day) {
                                setState(() {
                                  selectedDay = day!;
                                });
                              }),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _getActionsButtons(),
                          )
                        ],
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage("images/nutrimove_logo.png"),
                            ),
                            const Text(
                              "Olá, você ainda não decidiu o treino dessa semana, gostaria de gerar um novo ou importar o da semana passada?",
                              style: TextStyle(
                                color: grey,
                                fontSize: 32,
                              ),
                            ).withPadding(const EdgeInsets.symmetric(
                                horizontal: 120, vertical: 30)),
                            FilledButton(
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    fixedSize: const WidgetStatePropertyAll(
                                        Size(245, 62)),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(green)),
                                onPressed: () async {
                                  final response =
                                      await showBuildWeekTrainDialog(context,
                                          onConfirmed: (response) async {
                                    try {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final trainingPlan = await ApiManager()
                                          .generateCustomTrainWeek(
                                        response['goal'],
                                        response['fitnessLevel'],
                                        response['healthConditionsString'],
                                        response['preferencesString'],
                                        response['daysPerWeek'],
                                        response['sessionDuration'],
                                        response['planDurationWeeks'],
                                        response['customGoalsString'],
                                      );

                                      setState(() {
                                        dataTrainingPlan =
                                            Future.value(trainingPlan);
                                        exercisesState =
                                            ExercisesState.generatingTrain;
                                        isLoading = false;
                                      });
                                    } catch (e) {
                                      context.errorSnackBar(
                                          "Erro ao gerar treino: $e");
                                      setState(() {
                                        isLoading = false;
                                      });
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  });
                                  if (response != null) {
                                    print(response);
                                  }
                                },
                                child: const Text(
                                  "NOVO",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                )),
                            const SizedBox(height: 20),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fixedSize: const Size(245, 62),
                                    side: const BorderSide(color: orange)),
                                onPressed: () async {
                                  try {
                                    final reponse =
                                        await ApiManager().importTraininPlan(
                                      startOfWeek!,
                                      endOfWeek!,
                                    );
                                    setState(
                                      () {
                                        dataTrainingPlan = null;
                                      },
                                    );
                                  } catch (e) {
                                    context.errorSnackBar(
                                        "Erro ao importar treino: $e");
                                  }
                                },
                                child: const Text("IMPORTAR",
                                    style: TextStyle(
                                        color: orange,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                    ],
                  ).withPadding(const EdgeInsets.symmetric(horizontal: 20));
                }
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator(
                    color: orange,
                  ));
                }
                final List<String> headerRow = [
                  "Exercício",
                  "Séries",
                  "Repetições",
                  "Carga",
                  "Duração",
                  if (exercisesState == ExercisesState.generatingTrain ||
                      exercisesState == ExercisesState.updatingTrain)
                    "Dia"
                ];
                if (exercisesState != ExercisesState.generatingTrain &&
                    exercisesState != ExercisesState.updatingTrain) {
                  exercisesState = ExercisesState.withTrain;
                }
                final List<ModelExerciseDay> dayList = trainingPlan.exercises
                    .where((day) => day.day == selectedDay)
                    .toList();

                if (dayList.isEmpty &&
                    exercisesState == ExercisesState.withTrain) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (startOfWeek!.isBefore(DateTime.now())) {
                                  context.warningSnackBar(
                                      "Não é possível voltar no tempo!");
                                  return;
                                }
                                setState(() {
                                  startOfWeek = startOfWeek!
                                      .subtract(const Duration(days: 7));
                                  endOfWeek = endOfWeek!
                                      .subtract(const Duration(days: 7));
                                  dataTrainingPlan = ApiManager()
                                      .getWeekTrainingPlan(
                                          startOfWeek!, endOfWeek!);
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          RichText(
                              text: TextSpan(
                            text: DateFormat('dd/MM').format(startOfWeek!),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            children: [
                              const TextSpan(
                                text: " - ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              TextSpan(
                                text: DateFormat('dd/MM').format(endOfWeek!),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  startOfWeek =
                                      startOfWeek!.add(const Duration(days: 7));
                                  endOfWeek =
                                      endOfWeek!.add(const Duration(days: 7));
                                  dataTrainingPlan = ApiManager()
                                      .getWeekTrainingPlan(
                                          startOfWeek!, endOfWeek!);
                                });
                              },
                              icon: const Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoSlidingSegmentedControl<String>(
                              groupValue: selectedDay,
                              backgroundColor: Colors.white,
                              thumbColor: green,
                              children: const {
                                'Domingo': Text('Dom'),
                                'Segunda-feira': Text('Seg'),
                                'Terça-feira': Text('Ter'),
                                'Quarta-feira': Text('Qua'),
                                'Quinta-feira': Text('Qui'),
                                'Sexta-feira': Text("Sex"),
                                'Sábado': Text("Sáb")
                              },
                              onValueChanged: (day) {
                                setState(() {
                                  selectedDay = day!;
                                });
                              }),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _getActionsButtons(),
                          ),
                        ],
                      ),
                      const Center(
                        child: Text("Nenhum Treino hoje"),
                      )
                    ],
                  ).withPadding(const EdgeInsets.symmetric(horizontal: 20));
                }
                late List<ModelExercise> list;
                late Map<int, FlexColumnWidth> columnWidths;
                if (exercisesState == ExercisesState.generatingTrain) {
                  list = [];
                  for (final day in trainingPlan.exercises) {
                    list.addAll(day.exercises);
                  }
                  columnWidths = const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1)
                  };
                } else {
                  list = dayList.first.exercises;
                  columnWidths = const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1)
                  };
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (startOfWeek!.isBefore(DateTime.now())) {
                                  context.warningSnackBar(
                                      "Não é possível voltar no tempo!");
                                  return;
                                }

                                setState(() {
                                  startOfWeek = startOfWeek!
                                      .subtract(const Duration(days: 7));
                                  endOfWeek = endOfWeek!
                                      .subtract(const Duration(days: 7));
                                  dataTrainingPlan = ApiManager()
                                      .getWeekTrainingPlan(
                                          startOfWeek!, endOfWeek!);
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios)),
                          RichText(
                              text: TextSpan(
                            text: DateFormat('dd/MM').format(startOfWeek!),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            children: [
                              const TextSpan(
                                text: " - ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              TextSpan(
                                text: DateFormat('dd/MM').format(endOfWeek!),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  startOfWeek =
                                      startOfWeek!.add(const Duration(days: 7));
                                  endOfWeek =
                                      endOfWeek!.add(const Duration(days: 7));
                                  dataTrainingPlan = ApiManager()
                                      .getWeekTrainingPlan(
                                          startOfWeek!, endOfWeek!);
                                });
                              },
                              icon: const Icon(Icons.arrow_forward_ios)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoSlidingSegmentedControl<String>(
                              groupValue: selectedDay,
                              backgroundColor: Colors.white,
                              thumbColor: green,
                              children: const {
                                'Domingo': Text('Dom'),
                                'Segunda-feira': Text('Seg'),
                                'Terça-feira': Text('Ter'),
                                'Quarta-feira': Text('Qua'),
                                'Quinta-feira': Text('Qui'),
                                'Sexta-feira': Text("Sex"),
                                'Sábado': Text("Sáb")
                              },
                              onValueChanged: (day) {
                                setState(() {
                                  selectedDay = day!;
                                });
                              }),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: _getActionsButtons(),
                          ),
                        ],
                      ),
                      TableBuilder(
                          headerRow: headerRow,
                          rowBuilder: (context, index) {
                            final exercise = list[index];
                            return TableRow(children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  definirIconeTreino(exercise.name),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      exercise.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                exercise.sets ?? "",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                exercise.repetitions ?? "",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                exercise.equipment,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                exercise.duration,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (exercisesState ==
                                      ExercisesState.generatingTrain ||
                                  exercisesState ==
                                      ExercisesState.updatingTrain)
                                _calculateWeekDay(trainingPlan, list, index)
                            ]);
                          },
                          rowCount: list.length,
                          columnWidths: columnWidths)
                    ],
                  ).withPadding(const EdgeInsets.symmetric(horizontal: 20)),
                );
              },
            ),
    );
  }

  _getActionsButtons() {
    switch (exercisesState) {
      case ExercisesState.withoutTrain:
        return [
          FilledButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  maximumSize: const WidgetStatePropertyAll(Size(200, 50)),
                  backgroundColor: const WidgetStatePropertyAll(grey)),
              onPressed: () {
                context.warningSnackBar("Ainda não há um treino, gere um!");
              },
              child: const Text(
                "+ Mudar Exercício",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
        ];
      case ExercisesState.withTrain:
        return [
          FilledButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  maximumSize: const WidgetStatePropertyAll(Size(200, 50)),
                  backgroundColor: const WidgetStatePropertyAll(green)),
              onPressed: () async {
                final response = await showBuildWeekTrainDialog(context,
                    onConfirmed: (response) async {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    final trainingPlan =
                        await ApiManager().generateCustomTrainWeek(
                      response['goal'],
                      response['fitnessLevel'],
                      response['healthConditionsString'],
                      response['preferencesString'],
                      response['daysPerWeek'],
                      response['sessionDuration'],
                      response['planDurationWeeks'],
                      response['customGoalsString'],
                    );

                    setState(() {
                      dataTrainingPlan = Future.value(trainingPlan);
                      exercisesState = ExercisesState.updatingTrain;
                      isLoading = false;
                    });
                  } catch (e) {
                    context.errorSnackBar("Erro ao gerar treino: $e");
                    setState(() {
                      isLoading = false;
                    });
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                });
                if (response != null) {
                  print(response);
                }
              },
              child: const Text(
                "+ Mudar Exercício",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
        ];
      case ExercisesState.generatingTrain || ExercisesState.updatingTrain:
        return [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  maximumSize: const Size(200, 50),
                  side: const BorderSide(color: orange)),
              onPressed: () {
                setState(() {
                  exercisesState = ExercisesState.withTrain;
                  dataTrainingPlan = ApiManager()
                      .getWeekTrainingPlan(startOfWeek!, endOfWeek!);
                });
              },
              child: const Text("Cancelar", style: TextStyle(color: orange))),
          FilledButton(
              style: ButtonStyle(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  maximumSize: const WidgetStatePropertyAll(Size(200, 50)),
                  backgroundColor: const WidgetStatePropertyAll(orange)),
              onPressed: () async {
                final trainingPlan = await dataTrainingPlan;
                try {
                  final trainingPlanWithDates = {
                    ...trainingPlan!.toJson(),
                    'start_date': startOfWeek?.toIso8601String(),
                    'end_date': endOfWeek?.toIso8601String(),
                    'user_id': Hive.box('userData').get('id'),
                  };
                  print(trainingPlanWithDates);
                  try {} catch (e) {
                    print("FUDEU");
                  }
                  if (exercisesState == ExercisesState.generatingTrain) {
                    await ApiManager().saveTrainingPlan(trainingPlanWithDates);
                  } else {
                    await ApiManager()
                        .updateTrainingPlan(trainingPlanWithDates);
                  }
                  context.successSnackBar("Treino salvo com sucesso!");
                  setState(() {
                    exercisesState = ExercisesState.withTrain;
                    dataTrainingPlan = ApiManager()
                        .getWeekTrainingPlan(startOfWeek!, endOfWeek!);
                  });
                } catch (e) {
                  context.errorSnackBar("Erro ao salvar treino: $e");
                }
              },
              child: const Text(
                "+ Salvar",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
        ];
    }
  }

  (DateTime start, DateTime end) _getCurrentWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return (startOfWeek, endOfWeek);
  }

  Text _calculateWeekDay(ModelTrainingPlan trainingPlan,
      List<ModelExercise> exercises, int index) {
    int currentIndex = 0;
    Map<String, Color> colors = {
      "Domingo": Colors.red,
      "Segunda-feira": orange,
      "Terça-feira": Colors.yellow,
      "Quarta-feira": green,
      "Quinta-feira": Colors.blue,
      "Sexta-feira": Colors.indigo,
      "Sábado": Colors.purple,
    };

    for (final day in trainingPlan.exercises) {
      int dayStartIndex = currentIndex;
      int dayEndIndex = currentIndex + day.exercises.length - 1;

      if (index >= dayStartIndex && index <= dayEndIndex) {
        return Text(day.day, style: TextStyle(color: colors[day.day]));
      }

      currentIndex += day.exercises.length;
    }

    return const Text("Dia não encontrado",
        style: TextStyle(color: Colors.red));
  }

  Container definirIconeTreino(String goal) {
    String goalLower = goal.toLowerCase();

    if (goalLower.contains("emagrecer") || goalLower.contains("perder peso")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.fireplace, color: Colors.white),
      );
    } else if (goalLower.contains("ganhar massa") ||
        goalLower.contains("fortalecimento")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.fitness_center, color: Colors.white),
      );
    } else if (goalLower.contains("saúde") || goalLower.contains("bem-estar")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.greenAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.favorite, color: Colors.white),
      );
    } else if (goalLower.contains("flexibilidade") ||
        goalLower.contains("alongamento")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.purpleAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.accessibility_new, color: Colors.white),
      );
    } else if (goalLower.contains("resistência") ||
        goalLower.contains("cardio")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.directions_run, color: Colors.white),
      );
    } else if (goalLower.contains("velocidade") ||
        goalLower.contains("ficar mais rápido")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.yellowAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.flash_on, color: Colors.white),
      );
    } else if (goalLower.contains("panturrilha") ||
        goalLower.contains("pernas")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.tealAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.directions_walk, color: Colors.white),
      );
    } else if (goalLower.contains("força")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.blueGrey,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.fitness_center, color: Colors.white),
      );
    } else if (goalLower.contains("relaxamento") ||
        goalLower.contains("meditação")) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.lightBlueAccent,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.self_improvement, color: Colors.white),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.fitness_center, color: Colors.white),
      );
    }
  }
}

enum ExercisesState {
  withTrain,
  withoutTrain,
  generatingTrain,
  updatingTrain,
}
