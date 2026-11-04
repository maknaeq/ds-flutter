import { readFile } from 'node:fs/promises';

export const USERS_FILE = new URL('../data/users.json', import.meta.url);

export async function loadUsers(file = USERS_FILE) {
  try {
    return JSON.parse(await readFile(file, 'utf8'));
  } catch (error) {
    if (error.code === 'ENOENT') {
      throw new Error('Aucun utilisateur : lancez `npm run seed` avant de démarrer le serveur.');
    }
    throw error;
  }
}
