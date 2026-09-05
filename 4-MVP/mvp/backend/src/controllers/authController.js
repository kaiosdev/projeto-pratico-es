const { buscarPorFirebaseUid, buscarPorId, criar } = require('../models/userModel');

const syncUser = async (req, res) => {
  try {
    const { uid, email } = req.user; // Dados extraídos e validados pelo middleware
    const nome = req.body.nome || req.user.name || 'Usuário SlowDown';

    // 1. Login: usuário já sincronizado anteriormente
    const usuarioExistente = await buscarPorFirebaseUid(uid);
    if (usuarioExistente) {
      return res.status(200).json({
        mensagem: 'Usuário sincronizado.',
        usuario: usuarioExistente,
      });
    }

    // 2. Cadastro: primeira sincronização deste uid do Firebase
    const novoId = await criar({ firebaseUid: uid, nome, email });
    const novoUsuario = await buscarPorId(novoId);

    return res.status(201).json({
      mensagem: 'Usuário criado com sucesso!',
      usuario: novoUsuario,
    });

  } catch (error) {
    console.error('Erro ao sincronizar usuário:', error);
    return res.status(500).json({ mensagem: 'Erro interno no servidor de banco de dados.' });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { email, codigo } = req.body;

    // 1. Aqui você deve buscar no banco se existe um código válido para este e-mail
    // Exemplo de consulta:
    // const [rows] = await db.query('SELECT codigo FROM otp_table WHERE email = ? AND expira_em > NOW()', [email]);
    
    // 2. Lógica de Validação (substitua o '123456' pela query real)
    if (codigo === '123456') { 
      return res.status(200).json({ 
        mensagem: 'Código verificado com sucesso!' 
      });
    } else {
      return res.status(400).json({ 
        mensagem: 'Código incorreto ou expirado.' 
      });
    }
  } catch (error) {
    console.error('Erro na verificação de OTP:', error);
    return res.status(500).json({ mensagem: 'Erro interno no servidor.' });
  }
};

// ATENÇÃO: Exportar ambas as funções aqui
module.exports = { syncUser, verifyOtp };