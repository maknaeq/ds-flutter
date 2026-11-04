
# TP – Connexion à une API PHP avec Fetch

Ce projet contient un TP pédagogique destiné aux étudiants pour apprendre à créer une interface web qui interagit avec une API REST en PHP via la méthode `fetch()` en JavaScript.

## Objectif pédagogique

- Comprendre le fonctionnement de `fetch()` pour envoyer des données à un serveur.
- Mettre en place un formulaire de connexion HTML avec Bootstrap.
- Utiliser JavaScript pour récupérer les champs de formulaire, formater les données, et envoyer une requête `POST`.
- Consommer une API PHP qui retourne une réponse JSON.
- Afficher dynamiquement un message de retour (succès ou erreur).

## Fonctionnalités mises en œuvre

- Formulaire de connexion (HTML + Bootstrap)
- Envoi de données via `fetch()` (JS)
- Traitement des réponses JSON
- Vérification des identifiants dans une base de données (PHP + PDO)
- Bonus : sécurisation des mots de passe avec `password_hash()` et `password_verify()`

## Structure du projet

```
connexion-api/
├── index.html        # Formulaire de connexion avec Bootstrap
├── script.js         # JavaScript : récupération et envoi des données via Fetch
└── login.php         # API PHP : vérifie les identifiants et retourne une réponse JSON
```

## API PHP attendue

Le fichier `login.php` reçoit une requête `POST` contenant :

- `email` (string)
- `password` (string)

Il renvoie une réponse JSON :

```json
{
  "status": 200,
  "message": "Connexion réussie."
}
```

ou

```json
{
  "status": 400,
  "message": "Identifiants incorrects."
}
```

## Pré-requis

- PHP (7.4 ou +)
- Serveur local (ex. : WAMP, XAMPP, MAMP, ou `php -S`)
- Navigateur compatible ES6

## Lancer le TP

1. Cloner le projet
2. Lancer un serveur local dans le dossier
3. Accéder à `index.html` via `http://localhost`
4. Tester différents identifiants

## Bonus

La vérification des identifiants peut être faite avec :

```php
password_verify($password, $user['Password']);
```

Et les mots de passe doivent être stockés hachés avec :

```php
password_hash($password, PASSWORD_DEFAULT);
```

## Licence

📄 Ce projet est distribué sous la licence Academic Free License v3.0 ([AFL-3.0](https://opensource.org/licenses/AFL-3.0)).
