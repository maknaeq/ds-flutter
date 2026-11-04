// lib/services/auth_service.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService {
  // Méthode de hachage des mots de passe
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convertit le mot de passe en bytes
    final digest = sha256.convert(bytes); // Applique SHA-256
    return digest.toString(); // Retourne le hachage en chaîne hexadécimale
  }

  // Tableau associatif local des utilisateurs avec mots de passe hachés
  final Map<String, Map<String, dynamic>> _users = {
    'jean@example.com': {
      'password': '', // Sera initialisé dans le constructeur
      'firstName': 'Jean',
      'lastName': 'DUPONT',
      'role': 'User'
    },
    'julie@example.com': {
      'password': '',
      'firstName': 'Julie',
      'lastName': 'MARTIN',
      'role': 'Admin',
    },
  };

  AuthService() {
    // Initialiser les mots de passe hachés
    _users['jean@example.com']!['password'] = hashPassword('userpass');
    _users['julie@example.com']!['password'] = hashPassword('adminpass');
  }

  // Méthode de connexion
  Future<Map<String, dynamic>?> login(String email, String password) async {
    // Simule un délai pour imiter un appel réseau
    await Future.delayed(const Duration(seconds: 2));

    if (_users.containsKey(email)) {
      String hashedPassword = hashPassword(password);
      if (_users[email]!['password'] == hashedPassword) {
        return _users[email];
      }
    }
    return null;
  }
}
