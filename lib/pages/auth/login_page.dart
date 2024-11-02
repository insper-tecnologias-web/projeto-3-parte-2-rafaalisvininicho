import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:projeto/validators.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final key = GlobalKey<FormState>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AspectRatio(
              aspectRatio: 7,
              child: Image(
                image: AssetImage("images/nutrimove_logo.png"),
                fit: BoxFit.scaleDown,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: 350,
                minWidth: 300,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Entrar",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Digite seu email',
                            ),
                            validator: Validator.validateEmail,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              hintText: 'Digite sua senha',
                            ),
                            validator: Validator.validatePassword,
                          ),
                          const SizedBox(height: 16.0),
                          FilledButton(
                            onPressed: () {
                              // Navigate to the home page
                            },
                            child: Text(
                              'Entrar',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
