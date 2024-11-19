import 'package:flutter/material.dart';
import 'package:projeto/widgets/pop_up_builder.dart';

Future<dynamic> showBuildWeekTrainDialog(BuildContext context,
    {required Function onConfirmed}) {
  final metaController = TextEditingController();
  final _focusController = TextEditingController();
  final _problemaController = TextEditingController();
  final _customGoalsController = TextEditingController();
  final _daysPerWeekController = TextEditingController();
  final _sessionDurationController = TextEditingController();
  final _intensityController = TextEditingController();

  return showPopUp(
    context,
    title: 'Vamos montar o seu treino?',
    content: [
      // Primeira linha de campos
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primeiro campo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Qual sua meta fitness?'),
                  TextFormField(
                    controller: metaController,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Emagrecer, Ganhar massa muscular, etc',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Segundo campo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Foco do treino'),
                  TextFormField(
                    controller: _focusController,
                    decoration: const InputDecoration(
                      hintText: 'Sua resposta aqui',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      // Segunda linha de campos
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Terceiro campo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Objetivos específicos?'),
                  TextFormField(
                    controller: _customGoalsController,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Melhorar resistência, flexibilidade, etc',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Quarto campo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Algum problema físico?'),
                  TextFormField(
                    controller: _problemaController,
                    decoration: const InputDecoration(
                      hintText: 'Ex: Dor nas costas, joelho, etc',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      // Linha com os Dropdowns
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Duração do treino'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Dias por semana',
                    ),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('1')),
                      DropdownMenuItem(value: '2', child: Text('2')),
                      DropdownMenuItem(value: '3', child: Text('3')),
                    ],
                    onChanged: (value) {
                      _daysPerWeekController.text = value!;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Horas por dia',
                    ),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('1h')),
                      DropdownMenuItem(value: '2', child: Text('2h')),
                      DropdownMenuItem(value: '3', child: Text('3h')),
                    ],
                    onChanged: (value) {
                      _sessionDurationController.text = value!;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Intensidade',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Fácil', child: Text('Baixa')),
                      DropdownMenuItem(value: 'Médio', child: Text('Média')),
                      DropdownMenuItem(value: 'Difícil', child: Text('Alta')),
                    ],
                    onChanged: (value) {
                      _intensityController.text = value!;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
    onConfirmed: () async {
      await onConfirmed({
        'goal': metaController.text,
        'fitnessLevel': _focusController.text,
        'healthConditionsString': _problemaController.text,
        'preferencesString': '',
        'daysPerWeek': 3,
        'sessionDuration': 1,
        'planDurationWeeks': 4,
        'customGoalsString': _customGoalsController.text,
      });
      print('Gerar treino');
      return true;
    },
  );
}
