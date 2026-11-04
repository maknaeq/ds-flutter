# API d'authentification (Node.js + Express)

API REST utilisée par l'application Flutter pour la connexion des utilisateurs.

## Sécurité

- Mots de passe stockés uniquement sous forme de hash **bcrypt** (coût 12, sel inclus dans le hash).
- Servie en **HTTPS** (certificat local généré avec mkcert).
- Validation des entrées (format de l'email, longueur des champs, taille du corps limitée à 10 Ko).
- Même réponse pour un email inconnu et un mauvais mot de passe, avec un temps de réponse identique (pas d'énumération des comptes).
- Limitation à 10 tentatives échouées par IP toutes les 15 minutes (réponse `429`).
- CORS limité aux origines `localhost` / `127.0.0.1`.
- En-têtes de sécurité HTTP via `helmet`.

## Installation

Prérequis : Node.js 20 ou plus, et [mkcert](https://github.com/FiloSottile/mkcert).

```bash
npm install
npm run seed
```

`npm run seed` crée `data/users.json` avec les comptes de test, mots de passe hachés.

### Certificat HTTPS local

```bash
brew install mkcert
mkcert -install
mkdir -p certs
mkcert -cert-file certs/localhost.pem -key-file certs/localhost-key.pem localhost 127.0.0.1 ::1
```

`mkcert -install` ajoute l'autorité de certification locale de mkcert au trousseau du système, pour que le navigateur fasse confiance au certificat.

## Lancement

```bash
npm start
```

L'API écoute sur `https://localhost:8443/login` (port modifiable avec la variable `PORT`).

## Tests

```bash
npm test
```

## Endpoint

`POST /login`, corps en `application/x-www-form-urlencoded` ou `application/json` :

| Champ | Type |
|---|---|
| `email` | string |
| `password` | string |

Succès (`200`) :

```json
{
  "status": 200,
  "message": "Success",
  "id": 1,
  "firstName": "Jean",
  "lastName": "Dupont",
  "email": "jean@example.com",
  "role": 2
}
```

Erreur (`400`) :

```json
{ "status": 400, "message": "Error" }
```

Trop de tentatives (`429`) :

```json
{ "status": 429, "message": "Too many attempts" }
```

## Comptes de test

| Email | Mot de passe | Rôle |
|---|---|---|
| jean@example.com | 1234 | 2 (utilisateur) |
| julie@example.com | 4321 | 1 (administrateur) |
