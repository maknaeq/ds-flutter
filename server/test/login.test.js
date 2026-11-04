import { test, before, after } from 'node:test';
import assert from 'node:assert/strict';
import bcrypt from 'bcryptjs';
import { createApp } from '../src/app.js';

const users = [
  {
    id: 1,
    firstName: 'Jean',
    lastName: 'Dupont',
    email: 'jean@example.com',
    role: 2,
    passwordHash: bcrypt.hashSync('1234', 4),
  },
];

let server;
let baseUrl;

before(async () => {
  server = createApp({ users, loginLimit: 5 }).listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  baseUrl = `http://127.0.0.1:${server.address().port}`;
});

after(() => server.close());

function postForm(fields, headers = {}) {
  return fetch(`${baseUrl}/login`, {
    method: 'POST',
    headers,
    body: new URLSearchParams(fields),
  });
}

test('connexion réussie avec le profil sans le hash', async () => {
  const res = await postForm({ email: 'jean@example.com', password: '1234' });
  const body = await res.json();

  assert.equal(res.status, 200);
  assert.deepEqual(body, {
    status: 200,
    message: 'Success',
    id: 1,
    firstName: 'Jean',
    lastName: 'Dupont',
    email: 'jean@example.com',
    role: 2,
  });
});

test('email insensible à la casse', async () => {
  const res = await postForm({ email: 'JEAN@example.com', password: '1234' });
  assert.equal(res.status, 200);
});

test('accepte aussi un corps JSON', async () => {
  const res = await fetch(`${baseUrl}/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email: 'jean@example.com', password: '1234' }),
  });
  assert.equal(res.status, 200);
});

test('mauvais mot de passe', async () => {
  const res = await postForm({ email: 'jean@example.com', password: 'faux' });
  assert.equal(res.status, 400);
  assert.deepEqual(await res.json(), { status: 400, message: 'Error' });
});

test('utilisateur inconnu : même réponse que mauvais mot de passe', async () => {
  const res = await postForm({ email: 'inconnu@example.com', password: '1234' });
  assert.equal(res.status, 400);
  assert.deepEqual(await res.json(), { status: 400, message: 'Error' });
});

test('champs manquants ou invalides', async () => {
  for (const fields of [{}, { email: 'pas-un-email', password: '1234' }, { email: 'jean@example.com' }]) {
    const res = await postForm(fields);
    assert.equal(res.status, 400);
  }
});

test('JSON malformé', async () => {
  const res = await fetch(`${baseUrl}/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: '{"email":',
  });
  assert.equal(res.status, 400);
  assert.equal((await res.json()).status, 400);
});

test('CORS autorisé pour une origine localhost', async () => {
  const res = await postForm(
    { email: 'jean@example.com', password: '1234' },
    { Origin: 'http://localhost:53123' },
  );
  assert.equal(res.headers.get('access-control-allow-origin'), 'http://localhost:53123');
});

test('CORS refusé pour une autre origine', async () => {
  const res = await postForm(
    { email: 'jean@example.com', password: '1234' },
    { Origin: 'https://site-malveillant.com' },
  );
  assert.equal(res.headers.get('access-control-allow-origin'), null);
});

test('route inconnue', async () => {
  const res = await fetch(`${baseUrl}/autre`);
  assert.equal(res.status, 404);
});

test('trop de tentatives échouées : 429', async () => {
  let res;
  for (let i = 0; i < 6; i++) {
    res = await postForm({ email: 'jean@example.com', password: 'faux' });
  }
  assert.equal(res.status, 429);
  assert.equal((await res.json()).status, 429);
});
