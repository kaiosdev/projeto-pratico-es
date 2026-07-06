const db = require('../config/database');

const syncUser = async (req, res) => {
  try {
    const { uid, email } = req.user; // Dados extraídos e validados pelo middleware
    
    const nome = req.body.nome || req.user.name || 'Usuário SlowDown';

    // 1. Verifica se o firebase_uid já está no MySQL
    const [rows] = await db.query('SELECT * FROM users WHERE firebase_uid = ?', [uid]);

    if (rows.length > 0) {
      // Login: Usuário já existe, retorna os dados dele
      return res.status(200).json({
        mensagem: 'Usuário sincronizado.',
        usuario: rows[0]
      });
    }

    // 2. Cadastro: Usuário não existe, cria a linha no banco
    const [result] = await db.query(
      'INSERT INTO users (firebase_uid, nome, email, plano) VALUES (?, ?, ?, ?)',
      [uid, nome, email, 'padrao']
    );

    // 3. Busca o usuário recém-criado para devolver ao Flutter
    const [newUser] = await db.query('SELECT * FROM users WHERE id = ?', [result.insertId]);

    return res.status(201).json({
      mensagem: 'Usuário criado com sucesso!',
      usuario: newUser[0]
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