const { initializeApp, cert } = require('firebase-admin/app');
const path = require('path');
require('dotenv').config();

const serviceAccount = require(path.resolve(process.env.FIREBASE_SERVICE_ACCOUNT_PATH));

// Inicializa a instância padrão da aplicação Firebase
const app = initializeApp({
  credential: cert(serviceAccount)
});

module.exports = app;