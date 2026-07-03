const express = require('express');
const { syncUser } = require('../controllers/authController');
const verifyFirebaseToken = require('../middlewares/authMiddleware');

const router = express.Router();

// A rota exige que o verifyFirebaseToken seja executado antes do syncUser
router.post('/sync', verifyFirebaseToken, syncUser);

module.exports = router;