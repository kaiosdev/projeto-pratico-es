// src/models/userModel.js
// Camada Model (MVC): só fala com o banco de dados. Não tem regra de negócio aqui.

const { pool } = require('../config/database');

// Busca um usuário pelo uid do Firebase (usado em quase toda rota protegida)
async function buscarPorFirebaseUid(firebaseUid) {
  const [linhas] = await pool.query(
    'SELECT * FROM users WHERE firebase_uid = ? LIMIT 1',
    [firebaseUid]
  );
  return linhas[0]; // undefined se não encontrar
}

// Busca um usuário pelo id interno do MySQL
async function buscarPorId(id) {
  const [linhas] = await pool.query(
    'SELECT id, firebase_uid, nome, email, plano, criado_em FROM users WHERE id = ? LIMIT 1',
    [id]
  );
  return linhas[0];
}

// Cria um novo usuário vinculado a um uid do Firebase
async function criar({ firebaseUid, nome, email }) {
  const [resultado] = await pool.query(
    'INSERT INTO users (firebase_uid, nome, email) VALUES (?, ?, ?)',
    [firebaseUid, nome, email]
  );
  return resultado.insertId;
}

module.exports = { buscarPorFirebaseUid, buscarPorId, criar };
