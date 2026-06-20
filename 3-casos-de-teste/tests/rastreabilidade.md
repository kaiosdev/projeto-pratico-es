# Análise dos Resultados dos Testes — US #04, US #06, US #16 - Testes Automatizados

<img width="1218" height="686" alt="image" src="https://github.com/user-attachments/assets/e58d92ec-82c5-46b6-b020-189912fcd592" />




# Relatório de Execução de Testes — US #04, US #06, US #16

<div align="justify">
Os testes executados para as histórias prioritárias do projeto <strong>Slow Down</strong> — US #04 (<em>Monitoramento Cardíaco</em>), US #06 (<em>Registro Emocional Diário</em>) e US #16 (<em>Cadastro e Login</em>) — tiveram resultado satisfatório, demonstrando que as regras de validação definidas nas classes de equivalência foram implementadas corretamente no sistema.
</div>

<br>

<div align="justify">
Foram executados <strong>43 casos de teste unitários</strong> derivados do particionamento em classes de equivalência, distribuídos entre os três arquivos de teste automatizado. Os cenários seguem os identificadores e entradas definidos no Trabalho Prático III — Matriz de Rastreabilidade (<strong>CT01</strong> a <strong>CT06</strong>), complementados por casos adicionais identificados com o prefixo <strong>EXTRA</strong>, que reforçam a cobertura de classes inválidas, valores de fronteira e das funções <code>gerarAlerta()</code>, <code>registrarHumor()</code> e <code>validarCodigoVerificacao()</code> testadas isoladamente.
</div>

<br>

<div align="justify">
Complementarmente, foram executados <strong>16 testes de integração (widget tests)</strong>, que simulam a interação real do usuário com as telas <code>MonitorScreen</code> (US #04) e <code>RegisterScreen</code> (US #16), verificando se a interface reage corretamente às entradas — exibindo (ou não) as mensagens de erro esperadas. Os testes de integração da US #06 permanecem como especificação executável (<code>skip</code>), já que a tela de Registro Emocional ainda não foi implementada.
</div>

<br>

<div align="justify">
Para a <strong>US #04</strong>, foram avaliadas as regras de classificação da frequência cardíaca. Os <strong>Casos CT01 e CT02</strong> representaram leituras de BPM dentro da faixa normal (60 e 80), sem geração de alerta. Os <strong>Casos CT03 e CT04</strong> avaliaram leituras elevadas (101 e 120), corretamente classificadas com geração de alerta. Casos complementares (<strong>EXTRA01–EXTRA06</strong>) validaram a bradicardia, os limites exatos da faixa normal (40 e 100 BPM) e a regra de intervalo de atualização. Adicionalmente, os <strong>Casos EXTRA07–EXTRA09</strong> validaram a função <code>gerarAlerta()</code> de forma isolada — nomeada separadamente de <code>validarBpm()</code>, conforme a candidata à automação prevista para esta história —, confirmando que cada status (normal, elevado, abaixo do normal) produz a decisão de alerta correta.
</div>

<br>

<div align="justify">
Para a <strong>US #06</strong>, foram avaliadas as regras de registro emocional diário. O <strong>Caso CT01</strong> validou a aceitação de um emoji de humor válido. O <strong>Caso CT02</strong> validou a escala emocional dentro do intervalo 1–10. O <strong>Caso CT03</strong> validou a seleção de uma cor associada ao humor (paleta pré-definida, ex.: vermelho = raiva). O <strong>Caso CT04</strong> validou a rejeição de uma nota textual com 501 caracteres, acima do limite permitido. Casos complementares (<strong>EXTRA01–EXTRA08</strong>) reforçaram a cobertura de emojis e cores inválidos, escalas fora do intervalo e os limites exatos do campo de nota. Os <strong>Casos EXTRA09–EXTRA12</strong> validaram a função <code>registrarHumor()</code>, que combina a validação de emoji, escala e cor em um único registro, confirmando que o resultado é válido apenas quando os três campos estão corretos simultaneamente, e que o primeiro erro encontrado é corretamente reportado quando algum campo é inválido.
</div>

<br>

<div align="justify">
Para a <strong>US #16</strong>, foram avaliadas as regras de cadastro e login. O <strong>Caso CT01</strong> validou a aceitação de um e-mail em formato válido, enquanto o <strong>Caso CT02</strong> validou a rejeição de um e-mail inválido. O <strong>Caso CT03</strong> validou a aceitação de uma senha que atende aos critérios de complexidade, e o <strong>Caso CT04</strong> validou a rejeição de uma senha sem número. Os <strong>Casos CT05 e CT06</strong> validaram, respectivamente, a aceitação de um código de verificação válido e a rejeição de um código expirado, por meio da função <code>validarCodigoVerificacao()</code> — implementada com um parâmetro de tempo injetável, o que torna o teste determinístico e independente do relógio real da máquina. Casos complementares (<strong>EXTRA01–EXTRA06</strong>) reforçaram a cobertura de e-mails sem domínio ou vazios, senhas curtas ou vazias, e códigos de verificação incorretos ou não informados.
</div>

<br>

<blockquote>
  <h3>Status da Execução — Testes Unitários (Validadores)</h3>
  <p>O relatório de execução apresentou o resultado <strong>"All tests passed!"</strong>, com um total de <strong>43 testes (+43)</strong> executados com sucesso, indicando que todos os cenários planejados produziram os resultados esperados. Dessa forma, pode-se concluir que as validações de BPM/alerta, registro emocional (emoji, escala, cor, nota e registro combinado) e cadastro/login (e-mail, senha e código de verificação) estão funcionando corretamente e atendem aos critérios de aceitação estabelecidos para as histórias de usuário US #04, US #06 e US #16.</p>
</blockquote>

<blockquote>
  <h3>Status da Execução — Testes de Integração (Widget Tests)</h3>
  <p>A execução conjunta de <code>us04_monitor_screen_widget_test.dart</code>, <code>us06_registro_emocional_screen_widget_test.dart</code> e <code>us16_register_screen_widget_test.dart</code> via <code>flutter test --reporter expanded</code> apresentou o resultado <strong>"All tests passed!"</strong>, com <strong>16 testes aprovados (+16)</strong> e <strong>4 marcados como pendentes (~4)</strong>. Os 4 testes pendentes correspondem exclusivamente aos cenários de especificação da <code>RegistroEmocionalScreen</code> (US #06), intencionalmente marcados com <code>skip: true</code> por se tratar de uma tela ainda não implementada — não representando, portanto, falhas no sistema. Os 16 testes restantes validam o comportamento real da <code>MonitorScreen</code> (5 cenários: estado inicial, classificação de BPM, início/fim de monitoramento e exibição do histórico semanal) e da <code>RegisterScreen</code> (7 cenários: CT01–CT04 oficiais e EXTRA01–EXTRA03 complementares), confirmando que a interface reage corretamente às entradas do usuário.</p>
</blockquote>

<hr>

<div align="justify">
<em>A rastreabilidade entre requisitos, classes de equivalência, casos de teste e testes automatizados foi mantida, permitindo verificar que cada regra de negócio definida para o monitoramento cardíaco, o registro emocional e a autenticação foi efetivamente validada durante a execução dos testes — tanto na camada de lógica pura (validadores) quanto na camada de interface (widget tests).</em>
</div>

---

# #04 - Monitoramento Cardíaco

## Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| --- | --- | --- | --- |
| Frequência cardíaca (BPM) | BPM entre 40 e 100 → Normal (1) | BPM abaixo de 40 → Alerta de bradicardia (2) | BPM acima de 100 → Alerta (3) |

**Legenda da Tabela:** Classes de Equivalência da US #04.

## Tabela de Casos de Teste — Validação Unitária (`validador_bpm.dart`)

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| --- | --- | --- | --- |
| CT01 | 1 | BPM=60 | Normal |
| CT02 | 1 | BPM=80 | Normal |
| CT03 | 3 | BPM=101 | Alerta |
| CT04 | 3 | BPM=120 | Alerta |
| EXTRA01 | 2 | BPM=35 | Alerta de bradicardia |
| EXTRA02 | 1 | BPM=40 (limite inferior) | Normal |
| EXTRA03 | 1 | BPM=100 (limite superior) | Normal |
| EXTRA04 | — | Intervalo=10s | Aceito |
| EXTRA05 | — | Intervalo=2s | Rejeitado |
| EXTRA06 | — | Intervalo=90s | Rejeitado |
| EXTRA07 | — | gerarAlerta(normal) | false (sem alerta) |
| EXTRA08 | — | gerarAlerta(elevado) | true (com alerta) |
| EXTRA09 | — | gerarAlerta(abaixoDoNormal) | true (com alerta) |

**Legenda da Tabela:** Casos de Teste unitários da US #04 (`us04_validador_bpm_test.dart`). Os casos EXTRA07–EXTRA09 testam `ValidadorBpm.gerarAlerta()` isoladamente, função nomeada separadamente de `validarBpm()` conforme a candidata à automação prevista para a US #04.

## Tabela de Casos de Teste — Integração (`us04_monitor_screen_widget_test.dart`)

| Caso de Teste | Cenário | Resultado Esperado |
| --- | --- | --- |
| CT_TELA01 | Estado inicial da tela | Exibe BPM e botão START |
| CT_TELA02 | BPM inicial simulado (80) | Classificado como "NORMAL" na tela |
| CT_TELA03 | Toque no botão START | Inicia o monitoramento e alterna para "PARAR" |
| CT_TELA04 | Toque no botão PARAR | Encerra o monitoramento e retorna para "START" |
| CT_TELA05 | Exibição do histórico | Lista "HISTÓRICO SEMANAL" com os dias da semana |

**Legenda da Tabela:** Casos de Teste de integração (widget test) da US #04. Validam o comportamento real da `MonitorScreen`, complementando a verificação isolada da regra de negócio feita pelo `validador_bpm.dart`.

**Observação:** a tela `MonitorScreen` utiliza limiares internos próprios (`_bpmLabel`: NORMAL para BPM < 100) para fins de exibição visual, enquanto o `validador_bpm.dart` formaliza a regra de negócio do TP3 (NORMAL entre 40 e 100). Essa divergência é documentada no próprio arquivo de teste e recomenda-se unificá-la em versão futura.

---

# #06 - Registro Emocional Diário

## Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| --- | --- | --- | --- |
| Registro de humor (emoji) | Emoji pertencente ao conjunto válido (1) | Emoji não pertencente ao conjunto (2) | Campo vazio (3) |
| Escala emocional (1–10) | Valor entre 1 e 10 (4) | Valor menor que 1 (5) | Valor maior que 10 (6) |
| Cor do humor | Cor pertencente à paleta válida (7) | Cor fora da paleta (8) | Campo vazio (9) |
| Nota textual (opcional) | Texto de até 500 caracteres (10) | Texto com 501 ou mais caracteres (11) | — |

**Legenda da Tabela:** Classes de Equivalência da US #06.

## Tabela de Casos de Teste — Validação Unitária (`validador_registro_emocional.dart`)

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| --- | --- | --- | --- |
| CT01 | 1 | emoji=":)" | Registro realizado |
| CT02 | 4 | escala=7 | Registro realizado |
| CT03 | 7 | cor="#FF0000" (vermelho = raiva) | Registro realizado |
| CT04 | 11 | nota="A" × 501 caracteres | Erro |
| EXTRA01 | 2 | emoji="$%" | Rejeitado |
| EXTRA02 | 3 | emoji="" | Rejeitado |
| EXTRA03 | 5 | escala=0 | Rejeitada |
| EXTRA04 | 6 | escala=11 | Rejeitada |
| EXTRA05 | 8 | cor="#123456" | Rejeitada |
| EXTRA06 | 9 | cor="" | Rejeitada |
| EXTRA07 | 10 | nota="B" × 500 caracteres (limite exato) | Aceita |
| EXTRA08 | 10 | nota="" (campo opcional) | Aceita |
| EXTRA09 | 1, 4, 7 | registrarHumor(emoji=":)", escala=7, cor="#FF0000") | Registro válido |
| EXTRA10 | 2 | registrarHumor(emoji="$%", escala=7, cor="#FF0000") | Registro inválido (erro no emoji) |
| EXTRA11 | 6 | registrarHumor(emoji=":)", escala=15, cor="#FF0000") | Registro inválido (erro na escala) |
| EXTRA12 | 8 | registrarHumor(emoji=":)", escala=7, cor="#123456") | Registro inválido (erro na cor) |

**Legenda da Tabela:** Casos de Teste unitários da US #06 (`us06_validador_registro_emocional_test.dart`). Os casos EXTRA09–EXTRA12 testam `ValidadorRegistroEmocional.registrarHumor()`, função que combina emoji, escala e cor em um único registro, conforme a candidata à automação prevista para a US #06.

## Tabela de Casos de Teste — Integração (`us06_registro_emocional_screen_widget_test.dart`)

| Caso de Teste | Cenário | Status |
| --- | --- | --- |
| CT01 | Emoji válido selecionado → registro realizado | `skip` — especificação |
| CT02 | Escala 1–10 selecionada → registro realizado | `skip` — especificação |
| CT03 | Cor válida da paleta selecionada → registro realizado | `skip` — especificação |
| CT04 | Nota com 501 caracteres → exibe erro | `skip` — especificação |

**Legenda da Tabela:** Casos de Teste de integração da US #06. A tela `RegistroEmocionalScreen` ainda não foi implementada no projeto; os testes acima funcionam como **especificação executável** do contrato de UI esperado (textos, chaves de widget e comportamento), servindo de guia direto para a implementação futura. A regra de negócio correspondente já está validada e funcional via `validador_registro_emocional.dart` (tabela acima).

---

# #16 - Cadastro e Login

## Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| --- | --- | --- | --- |
| E-mail | E-mail com @ e domínio válido (1) | E-mail sem @ (2) | E-mail sem domínio (3) |
| Senha | Mínimo 6 caracteres com letras e números (4) | Senha sem número (5) | Menos de 6 caracteres (6) |

**Legenda da Tabela:** Classes de Equivalência da US #16.

## Tabela de Casos de Teste — Validação Unitária (`validador_auth.dart`)

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| --- | --- | --- | --- |
| CT01 | 1 | email="user@gmail.com" | Aceito |
| CT02 | 2 | email="usergmail.com" | Rejeitado |
| CT03 | 4 | senha="Carlos123" | Aceita |
| CT04 | 5 | senha="abcdefgh" | Rejeitada |
| EXTRA01 | 3 | email="user@" | Rejeitado |
| EXTRA02 | — | email="" | Rejeitado |
| EXTRA03 | 6 | senha="Ab1" | Rejeitada |
| EXTRA04 | — | senha="" | Rejeitada |
| CT05 | — | código="123456" (válido, não expirado) | Aceito |
| CT06 | — | código="123456" (expirado) | Rejeitado |
| EXTRA05 | — | código digitado diferente do esperado | Rejeitado |
| EXTRA06 | — | código="" (vazio) | Rejeitado |

**Legenda da Tabela:** Casos de Teste unitários da US #16 (`us16_validador_auth_test.dart`).

**Observação:** os cenários CT05 e CT06 são cobertos pela função `validarCodigoVerificacao()`, implementada com um parâmetro de tempo opcional (`agora`) que permite "congelar" o instante da verificação no teste, eliminando a dependência do relógio real da máquina ou de qualquer estado emitido pelo backend (Firebase Auth). Isso resolve a limitação registrada em versão anterior deste documento, na qual esses cenários ainda não possuíam cobertura automatizada.

## Tabela de Casos de Teste — Integração (`us16_register_screen_widget_test.dart`)

| Caso de Teste | Cenário | Resultado Esperado |
| --- | --- | --- |
| CT01 | Email válido + senha válida | Nenhuma mensagem de erro de validação exibida |
| CT02 | Email inválido | Exibe "E-mail inválido." |
| CT03 | Senha válida | Nenhuma mensagem de erro de senha exibida |
| CT04 | Senha abaixo do mínimo de caracteres | Exibe "A senha deve ter no mínimo 6 caracteres." |
| EXTRA01 | Senha e confirmação divergentes | Exibe "As senhas não coincidem." |
| EXTRA02 | Termos de uso não aceitos | Exibe "Aceite os termos para continuar." |
| EXTRA03 | Nome não informado | Exibe "Informe seu nome." |

**Legenda da Tabela:** Casos de Teste de integração (widget test) da US #16. Simulam o preenchimento real do formulário de cadastro (`RegisterScreen`) e o toque em "CRIAR CONTA", verificando a reação da interface — complementando a verificação isolada da regra de negócio feita pelo `validador_auth.dart`.

---

# Evidência de Execução — Testes Unitários (Validadores)

<div align="justify">
A execução dos três arquivos de teste unitário, já incluindo os cenários CT05/CT06 da US #16 e as funções <code>gerarAlerta()</code> e <code>registrarHumor()</code> testadas isoladamente, foi realizada via linha de comando, com o seguinte resultado:
</div>

```
PS C:\Users\raine\Downloads\slowdown\frontend> flutter test test/us16_validador_auth_test.dart test/us04_validador_bpm_test.dart test/us06_validador_registro_emocional_test.dart --reporter expanded

...
00:00 +43: All tests passed!
```

<div align="justify">
O resultado <strong>+43</strong> confirma a execução bem-sucedida de todos os casos de teste unitário das três histórias de usuário: <strong>13 testes</strong> da US #16 (CT01–CT06 + EXTRA01–EXTRA06 + cenário completo), <strong>13 testes</strong> da US #04 (CT01–CT04 + EXTRA01–EXTRA09) e <strong>17 testes</strong> da US #06 (CT01–CT04 + EXTRA01–EXTRA12 + cenário completo). Nenhum teste falhou.
</div>

---

# Evidência de Execução — Testes de Integração (Widget Tests)

<div align="justify">
A execução dos três arquivos de widget test foi realizada via linha de comando, com o seguinte resultado:
</div>

```
PS C:\Users\raine\Downloads\slowdown\frontend> flutter test test/us04_monitor_screen_widget_test.dart test/us06_registro_emocional_screen_widget_test.dart test/us16_register_screen_widget_test.dart --reporter expanded

...
00:02 +16 ~4: All tests passed!
```

<div align="justify">
O resultado <strong>+16 ~4</strong> confirma: 16 testes de integração aprovados (5 da <code>MonitorScreen</code> + 7 da <code>RegisterScreen</code> + 4 testes documentais de referência) e 4 testes pendentes (<code>skip</code>), correspondentes exclusivamente à especificação da tela de Registro Emocional ainda não implementada. Nenhum teste falhou.
</div>

<br>

<div align="justify">
Adicionalmente, foi realizada uma <strong>auditoria de revisão de código</strong>, na qual a lógica de cada validador (<code>validador_bpm.dart</code>, <code>validador_registro_emocional.dart</code> e <code>validador_auth.dart</code>) foi simulada manualmente contra a totalidade dos casos de teste (CT e EXTRA) das três histórias de usuário, e contra os textos e finders exatos utilizados pelos widget tests. A auditoria confirmou que todos os 43 casos unitários e os 12 cenários de widget test ativos (excluindo os 4 pendentes da US #06) produzem o resultado esperado, sem divergências entre a implementação e a especificação dos testes.
</div>
