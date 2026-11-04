import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:untitled/services/auth_service.dart';

AuthService _serviceRespondingWith(Object body, {int statusCode = 200}) {
  return AuthService(
    client: MockClient((request) async {
      return http.Response(
        body is String ? body : jsonEncode(body),
        statusCode,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }),
  );
}

void main() {
  test('envoie email et password en form-data via POST', () async {
    late http.Request sent;
    final service = AuthService(
      client: MockClient((request) async {
        sent = request;
        return http.Response(
          jsonEncode({
            'status': 200,
            'message': 'Success',
            'id': 1,
            'firstName': 'Jean',
            'lastName': 'Dupont',
            'email': 'jean@example.com',
            'role': 2,
          }),
          200,
        );
      }),
    );

    await service.login('jean@example.com', '1234');

    expect(sent.method, 'POST');
    expect(sent.bodyFields, {'email': 'jean@example.com', 'password': '1234'});
  });

  test('renvoie le profil quand le status JSON vaut 200', () async {
    final service = _serviceRespondingWith({
      'status': 200,
      'message': 'Success',
      'id': 1,
      'firstName': 'Jean',
      'lastName': 'Dupont',
      'email': 'jean@example.com',
      'role': 2,
      'token': 'abc',
    });

    final user = await service.login('jean@example.com', '1234');

    expect(user.id, 1);
    expect(user.fullName, 'Jean Dupont');
    expect(user.roleLabel, 'Utilisateur');
    expect(user.token, 'abc');
  });

  test('refuse la connexion quand le status JSON vaut 400', () async {
    final service = _serviceRespondingWith({'status': 400, 'message': 'Error'});

    expect(
      service.login('jean@example.com', 'mauvais'),
      throwsA(isA<AuthException>().having(
          (e) => e.message, 'message', 'Email ou mot de passe incorrect.')),
    );
  });

  test('signale une réponse qui n\'est pas du JSON', () async {
    final service = _serviceRespondingWith('<b>Fatal error</b>');

    expect(
      service.login('jean@example.com', '1234'),
      throwsA(isA<AuthException>()),
    );
  });

  test('signale une erreur HTTP du serveur', () async {
    final service = _serviceRespondingWith('', statusCode: 500);

    expect(
      service.login('jean@example.com', '1234'),
      throwsA(isA<AuthException>()),
    );
  });

  test('signale un serveur injoignable', () async {
    final service = AuthService(
      client: MockClient((request) async {
        throw http.ClientException('Connection refused');
      }),
    );

    expect(
      service.login('jean@example.com', '1234'),
      throwsA(isA<AuthException>().having((e) => e.message, 'message',
          contains('Impossible de joindre le serveur'))),
    );
  });
}
