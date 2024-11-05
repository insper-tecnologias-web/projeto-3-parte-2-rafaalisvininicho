import 'dart:convert';

class ModelUser {
  final int id;
  final String username;
  final String role;
  final String email;

  ModelUser({
    required this.id,
    required this.username,
    required this.role,
    required this.email,
  });

  factory ModelUser.fromJson(Map<String, dynamic> json) {
    print(json);
    print(json['is_superuser']);
    final role = json['role'];
    json = json['user'];
    return ModelUser(
      id: json['id'],
      username: utf8.decode(json['username'].codeUnits),
      role: role,
      email: json['email'],
    );
  }
  factory ModelUser.fromLoginJson(Map<String, dynamic> json) {
    print(json);
    return ModelUser(
      id: json['id'],
      username: utf8.decode(json['username'].codeUnits),
      role: json["role"],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'email': email,
    };
  }
}
