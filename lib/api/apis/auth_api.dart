part of './../api_manager.dart';

extension AuthApi on ApiManager {
  // Método para login
  Future<dynamic> login(String email, String password) async {
    try {
      final response = await post('auth/login/', {
        'email': email,
        'password': password,
      });
      _isAuthenticated = true;
      print(response);
      final user = ModelUser.fromJson(response);
      print(user.toJson());
      Hive.box('userData').put('id', user.id);
      Hive.box('userData').put('username', user.username);
      Hive.box('userData').put('email', user.email);
      Hive.box("userData").put("role", user.role);
      return response;
    } catch (error) {
      throw Exception('Erro ao fazer login: $error');
    }
  }

  // Método para logout
  Future<void> logout() async {
    // Aqui você pode fazer a requisição de logout, se necessário
    _isAuthenticated = false; // Atualiza o estado de autenticação
    // Notifica os ouvintes sobre a mudança de estado
  }
}
