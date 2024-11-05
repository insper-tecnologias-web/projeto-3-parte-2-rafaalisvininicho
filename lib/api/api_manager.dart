import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/api/models/model_exercise.dart';
import 'dart:convert';

import 'package:projeto/api/models/model_user.dart';

part 'apis/auth_api.dart';
part 'apis/users_api.dart';
part 'apis/exercises_api.dart';

class ApiManager extends ChangeNotifier {
  ApiManager._internal();
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() {
    return _instance;
  }
  final String _baseUrl = 'http://127.0.0.1:8000/';
  BuildContext? navigationContext;

  bool _isAuthenticated = false; // Estado de autenticação

  bool get isAuthenticated => _isAuthenticated; // Getter para o estado

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Erro na requisição GET: $error');
    }
  }

  Future<dynamic> post(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      endpoint = endpoint.replaceFirst(RegExp(r'^/'), '');
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Erro na requisição POST: $error');
    }
  }

  Future<dynamic> put(String endpoint, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Erro na requisição PUT: $error');
    }
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );
      return _handleResponse(response);
    } catch (error) {
      throw Exception('Erro na requisição DELETE: $error');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erro na API (Status: ${response.statusCode}): ${response.body}');
    }
  }
}
