require('../config/firebase'); // Garante a inicialização da instância
const { getAuth } = require('firebase-admin/auth');

const verifyFirebaseToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ mensagem: 'Token não fornecido ou formato inválido.' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    // Usa a API Modular do Node.js (getAuth) ao invés da antiga chamada admin.auth()
    const decodedToken = await getAuth().verifyIdToken(idToken);
    req.user = decodedToken; 
    next();
  } catch (error) {
    console.error('Erro na validação do token Firebase:', error);
    return res.status(401).json({ mensagem: 'Não autorizado. Token expirado ou inválido.' });
  }
};

module.exports = verifyFirebaseToken;