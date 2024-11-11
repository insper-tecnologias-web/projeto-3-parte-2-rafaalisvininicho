import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/api/api_manager.dart';
import 'package:projeto/extensions.dart';
import 'package:projeto/router.gr.dart';
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

    void _handleFormSubmmision() async {
      TextInput.finishAutofillContext();
      if (key.currentState!.validate()) {
        try {
          await ApiManager()
              .login(emailController.text, passwordController.text)
              .then((_) => {
                    context.successSnackBar('Login realizado com sucesso!'),
                    context.router.replace(const HomeRoute())
                  });
        } catch (error) {
          context.errorSnackBar('Erro ao fazer login', description: error.toString());
        }
      }
    }

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
              constraints: const BoxConstraints(
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
                          TextButton(
                            onPressed: () {
                              context.router.replace(const SignUpRoute());
                            }, 
                            child: Text(
                              'Não tem uma conta? Cadastre-se',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                            ),
                          FilledButton(
                            onPressed: _handleFormSubmmision,
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
