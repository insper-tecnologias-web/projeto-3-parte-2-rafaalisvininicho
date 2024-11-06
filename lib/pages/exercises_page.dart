import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Future<ModelTrainingPlan>? dataTrainingPlan;
  ExercisesState exercisesState = ExercisesState.withoutTrain;
  DateTime? startOfWeek;
  DateTime? endOfWeek;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final range = getCurrentWeekRange();
    startOfWeek = range.$1;
    endOfWeek = range.$2;
  }

  @override
  Widget build(BuildContext context) {
    return PadScaffold(
      title: "Exercícios",
      body: FutureBuilder<ModelTrainingPlan>(
        future: dataTrainingPlan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoSlidingSegmentedControl<String>(
                        backgroundColor: Colors.white,
                        thumbColor: green,
                        children: const {
                          'sunday': Text('Dom'),
                          'monday': Text('Seg'),
                          'tuesday': Text('Ter'),
                          'wednesday': Text('Qua'),
                          'thursday': Text('Qui'),
                          'friday': Text("Sex"),
                          'saturday': Text("Sáb")
                        },
                        onValueChanged: (int) {
                          print(int);
                        }),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: _getActionsButtons(),
                    )
                  ],
                ).withPadding(
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20)),
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
                                      borderRadius: BorderRadius.circular(10))),
                              fixedSize:
                                  const WidgetStatePropertyAll(Size(245, 62)),
                              backgroundColor:
                                  const WidgetStatePropertyAll(green)),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final response = await showBuildWeekTrainDialog(
                                context, onConfirmed: (response) async {
                              try {
                                print(response);
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
                                  exercisesState =
                                      ExercisesState.generatingTrain;
                                  isLoading = false;
                                });
                              } catch (e) {
                                context
                                    .errorSnackBar("Erro ao gerar treino: $e");
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
                                  borderRadius: BorderRadius.circular(10)),
                              fixedSize: const Size(245, 62),
                              side: const BorderSide(color: orange)),
                          onPressed: () {},
                          child: const Text("IMPORTAR",
                              style: TextStyle(
                                  color: orange,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ],
            );
          }
          final List<String> headerRow = [
            "Exercício",
            "Séries",
            "Repetições",
            "Carga",
            "Descanso"
          ];
          final List<ModelExercise> list =
              trainingPlan.exercises.first.exercises;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoSlidingSegmentedControl<String>(
                      children: const {
                        'sunday': Text('Dom'),
                        'monday': Text('Seg'),
                        'tuesday': Text('Ter'),
                        'wednesday': Text('Qua'),
                        'thursday': Text('Qui'),
                        'friday': Text("Sex"),
                        'saturday': Text("Sáb")
                      },
                      onValueChanged: (int) {
                        print(int);
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
                      Text(exercise.name),
                      Text(exercise.sets ?? ""),
                      Text(exercise.repetitions ?? ""),
                      Text(exercise.equipment),
                      Text(exercise.duration),
                    ]);
                  },
                  rowCount: list.length,
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  })
            ],
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
              onPressed: () {},
              child: const Text(
                "+ Mudar Exercício",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
        ];
      case ExercisesState.generatingTrain:
        return [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  maximumSize: const Size(200, 50),
                  side: const BorderSide(color: orange)),
              onPressed: () {},
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
                  };
                  print(trainingPlanWithDates);
                  await ApiManager().saveTrainingPlan(
                      ModelTrainingPlan.fromCreateJson(trainingPlanWithDates));
                  context.successSnackBar("Treino salvo com sucesso!");
                  setState(() {
                    exercisesState = ExercisesState.withTrain;
                    dataTrainingPlan = null;
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

  (DateTime start, DateTime end) getCurrentWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return (startOfWeek, endOfWeek);
  }
}

enum ExercisesState {
  withTrain,
  withoutTrain,
  generatingTrain,
}
