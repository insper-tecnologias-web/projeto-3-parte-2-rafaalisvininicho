import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projeto/api/api_manager.dart';
import 'package:projeto/api/models/model_user.dart';
import 'package:projeto/colors.dart';
import 'package:projeto/extensions.dart';
import 'package:projeto/validators.dart';
import 'package:projeto/widgets/pad_scaffold.dart';
import 'package:projeto/widgets/pop_up_builder.dart';
import 'package:projeto/widgets/table_builder.dart';

@RoutePage()
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Future<List<ModelUser>>? dataUsers;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: dataUsers ??= ApiManager().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            print("Erro ao carregar os usuários: ${snapshot.error}");
            return const Center(
              child: Text('Erro ao carregar os usuários'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Nenhum usuário encontrado'),
            );
          }
          final List<ModelUser> users = snapshot.data as List<ModelUser>;
          print("Total de usuários: ${users.length}");
          return PadScaffold(
              title: 'Usuários',
              actions: Form(
                child: FilledButton(
                    style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        maximumSize:
                            const WidgetStatePropertyAll(Size(200, 50)),
                        backgroundColor: const WidgetStatePropertyAll(green)),
                    onPressed: () async {
                      await showPopUp(context,
                          title: 'Adicionar Usuário',
                          content: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obrigatório';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Nome', hintText: 'Nome'),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              validator: Validator.validateEmail,
                              decoration: const InputDecoration(
                                  labelText: 'Email', hintText: 'Email'),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: Validator.validatePassword,
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                  labelText: 'Senha', hintText: 'Senha'),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione um role';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Role', hintText: 'Role'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'admin',
                                  child: Text('Administrador'),
                                ),
                                DropdownMenuItem(
                                  value: 'user',
                                  child: Text('Usuário'),
                                ),
                              ],
                              onChanged: (value) {
                                _roleController.text = value!;
                              },
                            ),
                          ], onConfirmed: () async {
                        final response = await ApiManager().createUser(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                            _roleController.text);

                        if (response != null) {
                          _nameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          _roleController.clear();
                          context.successSnackBar('Usuário criado com sucesso');
                          final updatedUsers = await ApiManager().getUsers();
                          setState(() {
                            dataUsers = Future.value(updatedUsers);
                          });
                        }
                      });
                    },
                    child: const Text(
                      '+ Adicionar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
              ),
              child: TableBuilder(
                  headerRow: const ['Nome', 'Email', 'Role', 'Ações'],
                  rowBuilder: (context, index) {
                    final user = users[index];
                    return TableRow(
                      children: [
                        Text(
                          user.username,
                        ),
                        Text(
                          user.email,
                        ),
                        Text(
                          user.role == 'admin' ? 'Administrador' : 'Usuário',
                          style: TextStyle(
                              color: user.role == 'admin' ? orange : green),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  _nameController.text = user.username;
                                  _emailController.text = user.email;
                                  _roleController.text = user.role;

                                  await showPopUp(context,
                                      title: 'Editar Usuário',
                                      content: [
                                        TextFormField(
                                          controller: _nameController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Campo obrigatório';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Nome',
                                              hintText: 'Nome'),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          enabled: false,
                                          readOnly: true,
                                          validator: Validator.validateEmail,
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                              labelText: 'Email',
                                              hintText: 'Email'),
                                        ),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<String>(
                                          value: user.role,
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Selecione um role';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'Role',
                                              hintText: 'Role'),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'admin',
                                              child: Text('Administrador'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'user',
                                              child: Text('Usuário'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            _roleController.text = value!;
                                          },
                                        ),
                                      ], onConfirmed: () async {
                                    final response = await ApiManager()
                                        .updateUser(
                                            user.id,
                                            _nameController.text,
                                            _emailController.text,
                                            _roleController.text);

                                    if (response != null) {
                                      _nameController.clear();
                                      _emailController.clear();
                                      _passwordController.clear();
                                      _roleController.clear();
                                      context.successSnackBar(
                                          'Usuário atualizado com sucesso');
                                      final updatedUsers =
                                          await ApiManager().getUsers();
                                      setState(() {
                                        dataUsers = Future.value(updatedUsers);
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.edit, color: orange)),
                            IconButton(
                                onPressed: () async {
                                  await showPopUp(context,
                                      title: "Deletar Usuário",
                                      content: [
                                        Text(
                                          "Deseja realmente deletar o usuário ${user.username}?",
                                          style: const TextStyle(color: grey),
                                        )
                                      ], onConfirmed: () async {
                                    final response =
                                        await ApiManager().deleteUser(user.id);
                                    if (response != null) {
                                      final updatedUsers =
                                          await ApiManager().getUsers();
                                      context.successSnackBar(
                                          "Usuário deletado com sucesso");
                                      setState(() {
                                        dataUsers = Future.value(updatedUsers);
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.delete, color: orange))
                          ],
                        )
                      ],
                    );
                  },
                  rowCount: users.length,
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(1)
                  }).withPadding(
                const EdgeInsets.all(16),
              ));
        });
  }
}
