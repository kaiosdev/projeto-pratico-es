const express = require('express');
const { syncUser, verifyOtp } = require('../controllers/authController');
const verifyFirebaseToken = require('../middlewares/authMiddleware');

const router = express.Router();

// 1. Rota de sincronização (US-16)
// Mantemos o verifyFirebaseToken aqui, pois só usuários autenticados no Firebase 
// devem conseguir sincronizar os dados no banco MySQL.
router.post('/sync', verifyFirebaseToken, syncUser);

// 2. Nova rota para OTP (US-16 - Critério de Aceitação 2 e 3)
// Esta rota é pública pois o usuário ainda está em processo de verificação de cadastro.
router.post('/verify-otp', verifyOtp);

module.exports = router;