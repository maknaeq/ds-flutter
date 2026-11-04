// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Importez AuthService
import 'profile_screen.dart'; // Importez ProfileScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Clé pour le formulaire
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService(); // Instanciation d'AuthService

  bool _isLoading = false; // État de chargement

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Méthode de connexion
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final user = await _authService.login(email, password);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: user),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView( // Ajout de SingleChildScrollView pour la réactivité
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assignation de la clé au formulaire
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Champ Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.mail),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // Validation de l'email
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    // Regex simple pour valider l'email
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Champ Mot de Passe
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true, // Masquer le texte
                  validator: (value) {
                    // Validation du mot de passe
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                // Bouton de Connexion ou Indicateur de Chargement
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _login,
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
