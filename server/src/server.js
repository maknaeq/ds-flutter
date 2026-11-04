import { readFile } from 'node:fs/promises';
import https from 'node:https';
import { createApp } from './app.js';
import { loadUsers } from './users.js';

const PORT = Number(process.env.PORT ?? 8443);
const CERT_FILE = new URL('../certs/localhost.pem', import.meta.url);
const KEY_FILE = new URL('../certs/localhost-key.pem', import.meta.url);

async function readCertificates() {
  try {
    return { cert: await readFile(CERT_FILE), key: await readFile(KEY_FILE) };
  } catch {
    throw new Error('Certificat introuvable : générez-le avec mkcert (voir README).');
  }
}

try {
  const [users, certificates] = await Promise.all([loadUsers(), readCertificates()]);
  https.createServer(certificates, createApp({ users })).listen(PORT, () => {
    console.log(`API disponible sur https://localhost:${PORT}/login`);
  });
} catch (error) {
  console.error(error.message);
  process.exit(1);
}
