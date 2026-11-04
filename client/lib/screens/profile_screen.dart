// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String role;

  const ProfileScreen({
    Key? key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil de l\'Utilisateur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Action de déconnexion
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Affichage des informations du profil
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Nom'),
              subtitle: Text('$firstName $lastName'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(email),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Rôle'),
              subtitle: Text(role),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Déconnexion en retournant à l'écran de connexion
                Navigator.pop(context);
              },
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
