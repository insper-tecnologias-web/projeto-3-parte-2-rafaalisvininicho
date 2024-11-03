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
    return ModelUser(
      id: json['id'],
      username: json['username'],
      role: json['role'],
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
