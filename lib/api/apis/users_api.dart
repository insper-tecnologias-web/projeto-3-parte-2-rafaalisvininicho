part of './../api_manager.dart';

extension UsersApi on ApiManager {
  Future<List<ModelUser>> getUsers() async {
    try {
      print('Buscando usuários...');
      final response = await get('auth/users/');
      print(response);
      final List<ModelUser> users = [];
      for (var user in response) {
        print(user);
        users.add(ModelUser.fromJson(user));
      }
      return users;
    } catch (error) {
      throw Exception('Erro ao buscar usuários: $error');
    }
  }

  Future<dynamic> createUser(
      String username, String email, String password, String role) async {
    try {
      username = utf8.encode(username).toString();
      final response = await post('auth/register/', {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      });
      return response;
    } catch (error) {
      throw Exception('Erro ao criar usuário: $error');
    }
  }

  Future<dynamic> updateUser(
      int id, String username, String email, String role) async {
    username = utf8.encode(username).toString();
    try {
      final response = await put('auth/users/edit/$id/', {
        'username': username,
        'email': email,
        'role': role,
      });
      return response;
    } catch (error) {
      throw Exception('Erro ao atualizar usuário: $error');
    }
  }

  Future<dynamic> deleteUser(int id) async {
    try {
      final response = await delete('auth/users/delete/$id/');
      return response;
    } catch (error) {
      throw Exception('Erro ao deletar usuário: $error');
    }
  }
}
