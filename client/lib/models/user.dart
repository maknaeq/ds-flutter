class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final int role;
  final String? token;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: (json['id'] as num).toInt(),
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        role: (json['role'] as num).toInt(),
        token: json['token'] as String?,
      );
    } on TypeError {
      throw const FormatException('Profil utilisateur incomplet dans la réponse');
    }
  }

  String get fullName => '$firstName $lastName';

  String get roleLabel {
    switch (role) {
      case 1:
        return 'Administrateur';
      case 2:
        return 'Utilisateur';
      default:
        return 'Rôle $role';
    }
  }
}
