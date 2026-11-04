import { mkdir, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import bcrypt from 'bcryptjs';
import { USERS_FILE } from '../src/users.js';

const SALT_ROUNDS = 12;

const seedUsers = [
  { id: 1, firstName: 'Jean', lastName: 'Dupont', email: 'jean@example.com', password: '1234', role: 2 },
  { id: 2, firstName: 'Julie', lastName: 'Martin', email: 'julie@example.com', password: '4321', role: 1 },
];

const users = await Promise.all(
  seedUsers.map(async ({ password, ...user }) => ({
    ...user,
    passwordHash: await bcrypt.hash(password, SALT_ROUNDS),
  })),
);

await mkdir(new URL('.', USERS_FILE), { recursive: true });
await writeFile(USERS_FILE, JSON.stringify(users, null, 2));
console.log(`${users.length} utilisateurs créés dans ${fileURLToPath(USERS_FILE)}`);
