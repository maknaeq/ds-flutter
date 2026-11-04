import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import bcrypt from 'bcryptjs';

const LOCAL_ORIGIN = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/;
const EMAIL_FORMAT = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const DUMMY_HASH = bcrypt.hashSync('mot-de-passe-factice', 12);

const loginError = { status: 400, message: 'Error' };

export function createApp({ users, loginLimit = 10 }) {
  const usersByEmail = new Map(users.map((user) => [user.email.toLowerCase(), user]));
  const app = express();

  app.disable('x-powered-by');
  app.use(helmet());
  app.use(cors({ origin: LOCAL_ORIGIN, methods: ['POST'] }));
  app.use(express.json({ limit: '10kb' }));
  app.use(express.urlencoded({ extended: false, limit: '10kb' }));

  const loginLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    limit: loginLimit,
    standardHeaders: 'draft-8',
    legacyHeaders: false,
    skipSuccessfulRequests: true,
    handler: (req, res) => {
      res.status(429).json({ status: 429, message: 'Too many attempts' });
    },
  });

  app.post('/login', loginLimiter, async (req, res) => {
    const { email, password } = req.body ?? {};

    const isValid =
      typeof email === 'string' &&
      typeof password === 'string' &&
      email.length <= 254 &&
      password.length > 0 &&
      password.length <= 72 &&
      EMAIL_FORMAT.test(email.trim());

    if (!isValid) {
      return res.status(400).json(loginError);
    }

    const user = usersByEmail.get(email.trim().toLowerCase());
    const passwordMatches = await bcrypt.compare(password, user?.passwordHash ?? DUMMY_HASH);

    if (!user || !passwordMatches) {
      return res.status(400).json(loginError);
    }

    return res.status(200).json({
      status: 200,
      message: 'Success',
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      role: user.role,
    });
  });

  app.use((req, res) => {
    res.status(404).json({ status: 404, message: 'Not found' });
  });

  app.use((error, req, res, next) => {
    const status = error.status >= 400 && error.status < 500 ? error.status : 500;
    res.status(status).json({ status, message: status === 500 ? 'Server error' : 'Bad request' });
  });

  return app;
}
