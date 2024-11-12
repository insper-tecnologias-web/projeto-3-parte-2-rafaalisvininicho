import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/extensions.dart';
import 'package:projeto/router.gr.dart';
import 'package:projeto/validators.dart';
import 'package:projeto/api/api_manager.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final theme = Theme.of(context);

    void _handleFormSubmmision() async {
    TextInput.finishAutofillContext();
    if (key.currentState!.validate()) {
      try {
        await ApiManager()
            .register(usernameController.text, emailController.text, passwordController.text)
            .then((_) => {
                  context.successSnackBar('Usuário cadastrado com sucesso!'),
                  ApiManager()
                    .login(emailController.text, passwordController.text)
                    .then((_) => {
                          context.successSnackBar('Login realizado com sucesso!'),
                          context.router.replace(const HomeRoute())
                        })});
      } catch (error) {
        context.errorSnackBar('Erro ao se cadastrar', description: error.toString());
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
                          Text(
                            'Cadastro',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nome',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: emailController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: Validator.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                            )
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: _handleFormSubmmision,
                            child: Text(
                              'Cadastrar',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
