require('dotenv').config();
const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/authRoutes');

const app = express();

app.use(cors());
app.use(express.json());

// Registra as rotas de autenticação
app.use('/auth', authRoutes);

const PORT = process.env.PORT || 3000;

// Escuta em 0.0.0.0 (não apenas localhost) para aceitar conexões do
// emulador Android, de dispositivos físicos na mesma rede, etc.
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor SlowDown rodando na porta ${PORT}`);
});