# Rastreabilidade de Telas

Este documento tem como objetivo apresentar a rastreabilidade das telas do sistema em relação às **Histórias de Usuário (US)** do projeto. 

As telas relacionadas encontram-se no diretório base:
<blockquote><code>frontend/lib/screens/</code></blockquote>

Foram listadas as Histórias de Usuário e as telas gerais que compõem a navegação base do aplicativo após a integração final.

<hr>

<details>
<summary><b>🧩 (US-01) - Meditação</b> <i>(kaiosdev/projeto-pratico-es#1)</i></summary>
<br>
<ul>
  <li><code>meditation_screen.dart</code> — <b>Biblioteca de Meditação:</b> tela de listagem das meditações disponíveis.</li>
  <li><code>meditation_session_screen.dart</code> — <b>Sessão de Meditação:</b> tela de execução de uma sessão de meditação.</li>
  <li><code>about_meditation_screen.dart</code> — <b>Sobre Meditação:</b> tela informativa sobre a prática de meditação.</li>
  <li><code>meditation_history_screen.dart</code> — <b>Histórico de Meditação:</b> tela de histórico das sessões realizadas.</li>
  <li><code>sleepcasts_screen.dart</code> — <b>Histórias para Dormir:</b> tela de conteúdos em áudio para auxiliar no sono.</li>
</ul>
</details>

<details>
<summary><b>🎵 (US-02) - Música</b> <i>(kaiosdev/projeto-pratico-es#2)</i></summary>
<br>
<ul>
  <li><code>music_screen.dart</code> — <b>Biblioteca Musical:</b> tela de listagem das faixas e playlists disponíveis.</li>
  <li><code>spotify_screen.dart</code> — <b>Spotify:</b> tela de integração e controle do player oficial do Spotify.</li>
</ul>
</details>

<details>
<summary><b>🐾 (US-03) - Pet Virtual</b> <i>(kaiosdev/projeto-pratico-es#3)</i></summary>
<br>
<ul>
  <li><code>pet_screen.dart</code> — Tela principal de visualização e interação com o pet virtual.</li>
  <li><code>pet_items_screen.dart</code> — Tela de gerenciamento dos itens e alimentação do pet.</li>
  <li><code>pet_skin_screen.dart</code> — Tela de seleção e personalização das skins do pet.</li>
  <li><code>missions_screen.dart</code> — <b>Missões:</b> tela de gamificação com tarefas diárias para recompensas do pet.</li>
</ul>
</details>

<details>
<summary><b>❤️ (US-04) - Monitoramento</b> <i>(kaiosdev/projeto-pratico-es#4)</i></summary>
<br>
<ul>
  <li><code>monitor_screen.dart</code> — <b>Monitor BPM:</b> tela principal de monitoramento dos batimentos cardíacos.</li>
  <li><code>health_sync_screen.dart</code> — <b>Sincronização de Saúde:</b> tela de integração com dados e sensores do dispositivo.</li>
  <li><code>report_screen.dart</code> — <b>Relatórios:</b> tela de visualização de estatísticas e métricas de saúde.</li>
</ul>
</details>

<details>
<summary><b>♿ (US-05) - Acessibilidade</b> <i>(kaiosdev/projeto-pratico-es#5)</i></summary>
<br>
<ul>
  <li><code>accessibility_screen.dart</code> — Tela de configuração das opções de acessibilidade (tamanho de fonte, contrastes).</li>
</ul>
</details>

<details>
<summary><b>🧠 (US-06) - Registro Emocional</b> <i>(kaiosdev/projeto-pratico-es#6)</i></summary>
<br>
<ul>
  <li><code>emotional_record_screen.dart</code> — Tela de registro do estado emocional diário (unificada com armazenamento local).</li>
  <li><code>emotional_history_screen.dart</code> — <b>Histórico Emocional:</b> tela de listagem dos humores registrados.</li>
  <li><code>emotional_thermometer_screen.dart</code> — <b>Termômetro Emocional:</b> tela de avaliação rápida do nível de estresse.</li>
</ul>
</details>

<details>
<summary><b>🎮 (US-09) - Minijogos</b> <i>(kaiosdev/projeto-pratico-es#9)</i></summary>
<br>
<ul>
  <li><code>games_screen.dart</code> — <b>Menu de Jogos:</b> tela de seleção dos minijogos disponíveis.</li>
  <li><code>quiz_screen.dart</code> — Tela do minijogo Quiz.</li>
  <li><code>race_screen.dart</code> — Tela do minijogo Corrida.</li>
  <li><code>checkers_screen.dart</code> — Tela do minijogo Damas.</li>
</ul>
</details>

<details>
<summary><b>⚙️ (US-15) - Configurações</b> <i>(kaiosdev/projeto-pratico-es#15)</i></summary>
<br>
<ul>
  <li><code>settings_screen.dart</code> — Tela de configurações gerais do aplicativo.</li>
  <li><code>notifications_screen.dart</code> — Tela de gerenciamento de alertas e notificações.</li>
  <li><code>offline_screen.dart</code> — Tela de gerenciamento do modo offline e downloads locais.</li>
  <li><code>premium_screen.dart</code> — Tela de assinatura e recursos da versão Premium.</li>
</ul>
</details>

<details>
<summary><b>🔒 (US-16) - Autenticação</b> <i>(kaiosdev/projeto-pratico-es#16)</i></summary>
<br>
<ul>
  <li><code>login_screen.dart</code> — Tela de autenticação do usuário (com suporte a Google Sign-In e Riverpod).</li>
  <li><code>register_screen.dart</code> — Tela de criação de nova conta.</li>
  <li><code>forgot_password_screen.dart</code> — Tela de recuperação e redefinição de senha.</li>
  <li><code>otp_verification_screen.dart</code> — Tela de verificação de e-mail via código OTP.</li>
  <li><code>onboarding_screen.dart</code> — Tela de boas-vindas e introdução ao aplicativo para novos usuários.</li>
  <li><code>profile_setup_screen.dart</code> — Tela de configuração inicial do perfil pós-cadastro.</li>
</ul>
</details>

<details>
<summary><b>🧭 Navegação Base e Funcionalidades Secundárias</b></summary>
<br>
<p>Telas estruturais que conectam os fluxos do aplicativo e recursos adicionais da arquitetura:</p>
<ul>
  <li><code>splash_screen.dart</code> — Tela de carregamento inicial do aplicativo.</li>
  <li><code>home_screen.dart</code> — Tela principal (Dashboard) do sistema.</li>
  <li><code>menu_screen.dart</code> — Menu de navegação lateral/global.</li>
  <li><code>profile_screen.dart</code> — Tela de visualização e edição dos dados do usuário.</li>
  <li><code>chatbot_screen.dart</code> — <b>Assistente Virtual:</b> tela de chat com IA para suporte de bem-estar.</li>
  <li><code>social_screen.dart</code> — Tela de interações sociais e comunidade.</li>
  <li><code>coming_soon_screen.dart</code> — Tela de fallback para funcionalidades em desenvolvimento.</li>
</ul>
</details>

<br>
<hr>

<div align="center">
  <sub><b>Trabalho Prático - Engenharia de Software</b><br>Instituto de Ciências Exatas e Tecnologia (ICET) - Universidade Federal do Amazonas (UFAM)</sub>
</div>
