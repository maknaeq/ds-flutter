import { spawnSync } from 'node:child_process';
import { mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const certsDir = fileURLToPath(new URL('../certs/', import.meta.url));
mkdirSync(certsDir, { recursive: true });

const result = spawnSync(
  'mkcert',
  [
    '-cert-file',
    `${certsDir}localhost.pem`,
    '-key-file',
    `${certsDir}localhost-key.pem`,
    'localhost',
    '127.0.0.1',
    '::1',
  ],
  { stdio: 'inherit' },
);

if (result.error) {
  console.error("mkcert est introuvable : installez-le puis lancez `mkcert -install` (voir README).");
  process.exit(1);
}

process.exit(result.status ?? 1);
