-- database.sql
-- Script de criação do banco de dados e tabela inicial de usuários.
-- A autenticação (senha, login social) é responsabilidade do Firebase Auth.
-- O MySQL aqui guarda apenas os dados do app vinculados ao usuário do Firebase.

CREATE DATABASE IF NOT EXISTS slowdown_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE slowdown_db;

-- Tabela de usuários (US-16: criar conta e fazer login via Firebase)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  firebase_uid VARCHAR(128) NOT NULL UNIQUE, -- identificador único que o Firebase gera para cada usuário
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  plano ENUM('padrao', 'premium') NOT NULL DEFAULT 'padrao',
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
