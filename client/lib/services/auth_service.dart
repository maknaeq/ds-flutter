// lib/services/auth_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/user.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<User> login(String email, String password) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            ApiConfig.loginUri,
            headers: {'Accept': 'application/json'},
            body: {'email': email, 'password': password},
          )
          .timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const AuthException('Le serveur met trop de temps à répondre.');
    } on http.ClientException {
      throw const AuthException(
          'Impossible de joindre le serveur. Vérifiez votre connexion.');
    }

    if (response.statusCode != 200) {
      throw AuthException('Erreur serveur (${response.statusCode}).');
    }

    final Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw const AuthException('Réponse du serveur illisible.');
    } on TypeError {
      throw const AuthException('Réponse du serveur illisible.');
    }

    if (json['status'] != 200) {
      throw const AuthException('Email ou mot de passe incorrect.');
    }

    try {
      return User.fromJson(json);
    } on FormatException catch (e) {
      throw AuthException(e.message);
    }
  }
}
