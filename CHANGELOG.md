# Changelog — SlowDown

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e [SemVer](https://semver.org/lang/pt-BR/).

## [1.0.0] — 2026-11-12
Entrega final do MVP (TP4).

### Adicionado
- Acesso pelo Menu às telas de Missões, Jogos e Offline.
- Onboarding guiado exibido no primeiro acesso após a verificação do código.
- Documentação do sistema v2.0 (`5-documentacao/`), com diagramas UML em PlantUML.
- Guia de contribuição (Git Flow e commits semânticos) e modelo de Pull Request.

### Corrigido
- Botão "Sair" agora encerra a sessão do Firebase, apaga o token local e volta ao login.

### Alterado
- Monitor de BPM passa a usar o `ValidadorBpm` para classificar a leitura (60–100 BPM = normal).
- `.gitignore` da raiz passa a ignorar dependências e artefatos de build.
