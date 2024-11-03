import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projeto/colors.dart';
import 'package:projeto/extensions.dart';

class PadScaffold extends StatelessWidget {
  const PadScaffold(
      {super.key,
      required this.child,
      this.title = "",
      this.subtitle = "",
      this.actions});
  final Widget child;
  final String title;
  final String subtitle;
  final Widget? actions;
  @override
  Widget build(BuildContext context) {
    final username = Hive.box("userData").get("username") ?? "";
    final isAdm = Hive.box("userData").get("role") == "admin" ? true : false;
    return Scaffold(
      backgroundColor: beige,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(color: grey, fontSize: 12),
                        ),
                      ],
                    ),
                    if (actions != null) actions!,
                    if (actions == null) const SizedBox(width: 16),
                  ],
                ).withPadding(
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
          Container(
              color: Colors.white,
              width: 324,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            isAdm ? "Administrador" : "Usuário",
                            style: const TextStyle(color: grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16),
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        decoration: BoxDecoration(
                          color: green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.person_outlined,
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ).withPadding(
                const EdgeInsets.all(16),
              )),
        ],
      ),
    );
  }
}
