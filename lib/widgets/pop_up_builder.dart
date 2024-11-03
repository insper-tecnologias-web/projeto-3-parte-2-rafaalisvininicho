import 'package:flutter/material.dart';
import 'package:projeto/colors.dart';

Future<dynamic> showPopUp(context,
    {required String title,
    required List<Widget> content,
    required Function onConfirmed}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
        actions: <Widget>[
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: orange),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              fixedSize: const Size(167, 40),
            ),
            onPressed: () {
              try {
                Navigator.of(context).pop(false);
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Cancelar', style: TextStyle(color: orange)),
          ),
          FilledButton(
            style: ButtonStyle(
                fixedSize: const WidgetStatePropertyAll(Size(167, 40)),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
                backgroundColor: const WidgetStatePropertyAll(green)),
            onPressed: () {
              try {
                onConfirmed();
                Navigator.of(context).pop(true);
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
}
