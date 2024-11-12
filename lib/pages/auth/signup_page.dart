import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/extensions.dart';
import 'package:projeto/router.gr.dart';
import 'package:projeto/validators.dart';
import 'package:projeto/api/api_manager.dart';

@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _passwordsMatch = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch = _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();
    final key = GlobalKey<FormState>();

    void _handleFormSubmmision() async {
    TextInput.finishAutofillContext();
    if (key.currentState!.validate()) {
      try {
        await ApiManager()
            .register(usernameController.text, emailController.text, passwordController.text)
            .then((_) => {
                  context.successSnackBar('Usuário cadastrado com sucesso!'),
                  ApiManager().login(emailController.text, passwordController.text).then((_) => {
                    context.router.replace(const HomeRoute())
                  })
                });
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: Validator.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            // onChanged: (_) => _checkPasswordsMatch(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirmar Senha',
                              errorText: _passwordsMatch ? null : 'As senhas não coincidem',
                            ),
                            onChanged: (_) => _checkPasswordsMatch(),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _passwordsMatch ? () {
                              _handleFormSubmmision();
                            } : null,
                            child: const Text('Cadastrar'),
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
