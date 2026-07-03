// backend/src/controllers/humorController.js
const db = require('../config/db'); // Ajuste o caminho conforme o seu ficheiro de conexão ao banco

const registrarHumor = async (req, res) => {
    try {
        // O usuario_id virá do token JWT (middleware de autenticação)
        const usuario_id = req.user.id; 
        const { nivel_humor, nota } = req.body;

        // Validação da [RN04]
        if (nivel_humor < 1 || nivel_humor > 10) {
            return res.status(400).json({ error: 'O nível de humor deve estar entre 1 e 10.' });
        }
        if (nota && nota.length > 500) {
            return res.status(400).json({ error: 'A nota não pode exceder 500 caracteres.' });
        }

        // Pega a data atual do servidor no formato YYYY-MM-DD
        const data_registro = new Date().toISOString().split('T')[0];

        // Consulta SQL com lógica de "Upsert" (Insert or Update)
        const sql = `
            INSERT INTO registros_emocionais (usuario_id, data_registro, nivel_humor, nota)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
            nivel_humor = VALUES(nivel_humor), 
            nota = VALUES(nota)
        `;

        await db.execute(sql, [usuario_id, data_registro, nivel_humor, nota || null]);

        res.status(200).json({ message: 'Registro emocional salvo com sucesso!' });
    } catch (error) {
        console.error('Erro ao registrar humor:', error);
        res.status(500).json({ error: 'Erro interno no servidor de banco de dados.' });
    }
};

module.exports = { registrarHumor };