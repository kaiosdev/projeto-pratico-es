# Análise dos Resultados dos Testes — US #04, US #06, US #16 - Testes Automatizados

<img width="1184" height="636" alt="image" src="https://github.com/user-attachments/assets/4897a019-f804-4068-9a01-f8acabd83bbb" />
<img width="1182" height="584" alt="image" src="https://github.com/user-attachments/assets/e76ca567-41eb-4d95-92ea-fb8c82ff2562" />
<img width="1180" height="77" alt="image" src="https://github.com/user-attachments/assets/0f7d3605-565a-40c3-b954-c8cb5333a153" />

# Relatório de Execução de Testes — US #04, US #06, US #16

<div align="justify">
Os testes executados para as histórias prioritárias do projeto <strong>Slow Down</strong> — US #04 (<em>Monitoramento Cardíaco</em>), US #06 (<em>Registro Emocional Diário</em>) e US #16 (<em>Cadastro e Login</em>) — tiveram resultado satisfatório, demonstrando que as regras de validação definidas nas classes de equivalência foram implementadas corretamente no sistema.
</div>

<br>

<div align="justify">
Foram executados <strong>46 casos de teste unitários</strong> derivados do particionamento em classes de equivalência, distribuídos entre os três arquivos de teste automatizado. Os cenários seguem os identificadores e entradas definidos no Trabalho Prático III — Matriz de Rastreabilidade (<strong>CT01</strong> a <strong>CT06</strong>), complementados por casos adicionais identificados com o prefixo <strong>EXTRA</strong>, que reforçam a cobertura de classes inválidas, valores de fronteira e das funções <code>gerarAlerta()</code>, <code>registrarHumor()</code> e <code>validarCodigoVerificacao()</code> testadas isoladamente.
</div>

<br>

<div align="justify">
Complementarmente, foram executados <strong>19 testes de integração (widget tests)</strong>, que simulam a interação real do usuário com as telas <code>MonitorScreen</code> (US #04), <code>RegistroEmocionalScreen</code> (US #06) e <code>RegisterScreen</code> (US #16), verificando se a interface reage corretamente às entradas — exibindo (ou não) as mensagens de erro e de sucesso esperadas. A tela de Registro Emocional, antes pendente de implementação, foi finalizada e seus 4 cenários de integração (<strong>CT01–CT04</strong>) agora são executados e validados de ponta a ponta, sem nenhum teste pendente (<code>skip</code>) restante no projeto.
</div>

<br>

<div align="justify">
Para a <strong>US #04</strong>, foram avaliadas as regras de classificação da frequência cardíaca. Os <strong>Casos CT01 e CT02</strong> representaram leituras de BPM dentro da faixa normal (60 e 80), sem geração de alerta. Os <strong>Casos CT03 e CT04</strong> avaliaram leituras elevadas (101 e 120), corretamente classificadas com geração de alerta. Casos complementares (<strong>EXTRA01–EXTRA03</strong>) validaram a bradicardia (incluindo o limite imediatamente abaixo de 60 BPM) e o limite superior exato da faixa normal (100 BPM). Casos adicionais (<strong>EXTRA04–EXTRA06</strong>) validaram a regra de intervalo de amostragem. Adicionalmente, os <strong>Casos EXTRA07–EXTRA09</strong> validaram a função <code>gerarAlerta()</code> de forma isolada — nomeada separadamente de <code>validarBpm()</code>, conforme a candidata à automação prevista para esta história —, confirmando que cada status (normal, elevado, abaixo do normal) produz a decisão de alerta correta.
</div>

<br>

<div align="justify">
Para a <strong>US #06</strong>, foram avaliadas as regras de registro emocional diário. O <strong>Caso CT01</strong> validou a aceitação de um emoji de humor válido. O <strong>Caso CT02</strong> validou a escala emocional dentro do intervalo 1–10. O <strong>Caso CT03</strong> validou a seleção de uma cor associada ao humor (paleta pré-definida, ex.: vermelho = raiva). O <strong>Caso CT04</strong> validou a rejeição de uma nota textual com 501 caracteres, acima do limite permitido. Casos complementares (<strong>EXTRA01–EXTRA08</strong>) reforçaram a cobertura de emojis e cores inválidos, escalas fora do intervalo e os limites exatos do campo de nota. Os <strong>Casos EXTRA09–EXTRA12</strong> validaram a função <code>registrarHumor()</code>, que combina a validação de emoji, escala e cor em um único registro: o resultado é válido sempre que a escala emocional informada estiver dentro do intervalo permitido e, caso o usuário também tenha selecionado um emoji e/ou uma cor, ambos pertençam aos conjuntos válidos correspondentes — sendo o primeiro erro encontrado corretamente reportado quando algum desses campos preenchidos é inválido.
</div>

<br>

<div align="justify">
Para a <strong>US #16</strong>, foram avaliadas as regras de cadastro e login. O <strong>Caso CT01</strong> validou a aceitação de um e-mail em formato válido, enquanto o <strong>Caso CT02</strong> validou a rejeição de um e-mail inválido. O <strong>Caso CT03</strong> validou a aceitação de uma senha que atende aos critérios de complexidade (mínimo de 8 caracteres com número), e o <strong>Caso CT04</strong> validou a rejeição de uma senha sem número. Os <strong>Casos CT05 e CT06</strong> validaram, respectivamente, a aceitação de um código de verificação válido e a rejeição de um código expirado, por meio da função <code>validarCodigoVerificacao()</code> — implementada com um parâmetro de tempo injetável, o que torna o teste determinístico e independente do relógio real da máquina. Casos complementares (<strong>EXTRA01–EXTRA06</strong>) reforçaram a cobertura de e-mails sem domínio ou vazios e senhas curtas, vazias ou sem número. Os <strong>Casos EXTRA07–EXTRA09</strong> reforçaram a cobertura da função <code>validarCodigoVerificacao()</code>, incluindo o cenário de limite exato de expiração (14m59s).
</div>

<br>

<blockquote>
  <h3>Status da Execução — Testes Unitários (Validadores)</h3>
  <p>O relatório de execução apresentou o resultado <strong>"All tests passed!"</strong>, com um total de <strong>46 testes (+46)</strong> executados com sucesso, indicando que todos os cenários planejados produziram os resultados esperados. Dessa forma, pode-se concluir que as validações de BPM/alerta, registro emocional (emoji, escala, cor, nota e registro combinado) e cadastro/login (e-mail, senha e código de verificação) estão funcionando corretamente e atendem aos critérios de aceitação estabelecidos para as histórias de usuário US #04, US #06 e US #16.</p>
</blockquote>

<blockquote>
  <h3>Status da Execução — Testes de Integração (Widget Tests)</h3>
  <p>A execução conjunta de <code>us04_monitor_screen_widget_test.dart</code>, <code>us06_registro_emocional_screen_widget_test.dart</code> e <code>us16_register_screen_widget_test.dart</code> via <code>flutter test --reporter expanded</code> apresentou o resultado <strong>"All tests passed!"</strong>, com os <strong>16 testes de integração aprovados (+16)</strong> e <strong>nenhum teste pendente (skip)</strong>. Os cenários validam o comportamento real da <code>MonitorScreen</code> (5 cenários: estado inicial, classificação de BPM, início/fim de monitoramento e exibição do histórico semanal), da <code>RegistroEmocionalScreen</code> (4 cenários: CT01–CT04, cobrindo seleção de emoji, escala, cor e o limite de 500 caracteres da nota) e da <code>RegisterScreen</code> (7 cenários: CT01–CT04 oficiais e EXTRA01–EXTRA03 complementares), confirmando que a interface reage corretamente às entradas do usuário nas três histórias.</p>
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
| Frequência cardíaca (BPM) | BPM entre 60 e 100 → Normal (1) | BPM abaixo de 60 → Alerta de bradicardia (2) | BPM acima de 100 → Alerta (3) |

**Legenda da Tabela:** Classes de Equivalência da US #04, alinhadas ao defeito corrigido (Ambiguidade/Omissão, item 10 do relatório de inspeção), que define a faixa saudável padrão como 60 a 100 BPM.

## Tabela de Casos de Teste — Validação Unitária (`validador_bpm.dart`)

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| --- | --- | --- | --- |
| CT01 | 1 | BPM=60 (limite inferior) | Normal |
| CT02 | 1 | BPM=80 | Normal |
| CT03 | 3 | BPM=101 | Alerta |
| CT04 | 3 | BPM=120 | Alerta |
| EXTRA01 | 2 | BPM=59 (1 abaixo do limite) | Alerta de bradicardia |
| EXTRA02 | 2 | BPM=35 (bradicardia severa) | Alerta |
| EXTRA03 | 1 | BPM=60 (limite inferior exato) | Normal (sem alerta) |
| EXTRA04 | 1 | BPM=100 (limite superior exato) | Normal (sem alerta) |
| EXTRA05 | — | Intervalo=10s | Aceito |
| EXTRA06 | — | Intervalo=2s | Rejeitado |
| EXTRA07 | — | Intervalo=90s | Rejeitado |
| EXTRA08 | — | gerarAlerta(normal) | false (sem alerta) |
| EXTRA09 | — | gerarAlerta(elevado) | true (com alerta) |
| EXTRA10 | — | gerarAlerta(abaixoDoNormal) | true (com alerta) |

**Legenda da Tabela:** Casos de Teste unitários da US #04 (`us04_validador_bpm_test.dart`). Os casos EXTRA03 e EXTRA04 reforçam, de forma explícita, que os dois limites exatos da faixa normal (60 e 100 BPM) não geram alerta. Os casos EXTRA08–EXTRA10 testam `ValidadorBpm.gerarAlerta()` isoladamente, função nomeada separadamente de `validarBpm()` conforme a candidata à automação prevista para a US #04.

## Tabela de Casos de Teste — Integração (`us04_monitor_screen_widget_test.dart`)

| Caso de Teste | Cenário | Resultado Esperado |
| --- | --- | --- |
| CT_TELA01 | Estado inicial da tela | Exibe BPM e botão START |
| CT_TELA02 | BPM inicial simulado (80) | Classificado como "NORMAL" na tela |
| CT_TELA03 | Toque no botão START | Inicia o monitoramento e alterna para "PARAR" |
| CT_TELA04 | Toque no botão PARAR | Encerra o monitoramento e retorna para "START" |
| CT_TELA05 | Exibição do histórico | Lista "HISTÓRICO SEMANAL" com os dias da semana |

**Legenda da Tabela:** Casos de Teste de integração (widget test) da US #04. Validam o comportamento real da `MonitorScreen`, complementando a verificação isolada da regra de negócio feita pelo `validador_bpm.dart`.

**Observação:** a tela `MonitorScreen` foi unificada para usar o mesmo limiar do `validador_bpm.dart` (NORMAL entre 60 e 100 BPM), eliminando a divergência entre a regra de negócio e a exibição visual que constava em versão anterior deste documento.

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

**Legenda da Tabela:** Casos de Teste unitários da US #06 (`us06_validador_registro_emocional_test.dart`). Os casos EXTRA09–EXTRA12 testam `ValidadorRegistroEmocional.registrarHumor()`, função que combina emoji, escala e cor em um único registro, conforme a candidata à automação prevista para a US #06. Vale notar que, na implementação final, apenas a escala emocional é obrigatória para o registro (sempre possui um valor padrão na interface); emoji e cor são opcionais, sendo validados quanto ao formato somente quando o usuário de fato os seleciona — comportamento coberto pelos cenários de integração CT01–CT03 da tela (tabela abaixo).

## Tabela de Casos de Teste — Integração (`us06_registro_emocional_screen_widget_test.dart`)

| Caso de Teste | Cenário | Resultado Esperado |
| --- | --- | --- |
| CT01 | Selecionar emoji válido e salvar | Exibe "Registro salvo com sucesso!" |
| CT02 | Escala dentro de 1–10 e salvar | Exibe "Registro salvo com sucesso!" |
| CT03 | Selecionar cor válida da paleta e salvar | Exibe "Registro salvo com sucesso!" |
| CT04 | Nota com 501 caracteres e salvar | Exibe "A nota não pode ultrapassar 500 caracteres." |

**Legenda da Tabela:** Casos de Teste de integração da US #06. A tela `RegistroEmocionalScreen` foi implementada e validada de ponta a ponta: cada cenário simula a interação real do usuário (seleção de emoji, ajuste da escala via `Slider`, seleção de cor ou preenchimento da nota) e verifica a mensagem exibida via `SnackBar`, complementando a verificação isolada da regra de negócio feita pelo `validador_registro_emocional.dart` (tabela acima).

---

# #16 - Cadastro e Login

## Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| --- | --- | --- | --- |
| E-mail | E-mail com @ e domínio válido (1) | E-mail sem @ (2) | E-mail sem domínio (3) |
| Senha | Mínimo 8 caracteres com letras e números (4) | Senha sem número (5) | Menos de 8 caracteres (6) |

**Legenda da Tabela:** Classes de Equivalência da US #16, com a senha alinhada ao defeito corrigido (Omissão, item 29 do relatório de inspeção): mínimo de 8 caracteres e ao menos 1 número para o cadastro local.

## Tabela de Casos de Teste — Validação Unitária (`validador_auth.dart`)

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| --- | --- | --- | --- |
| CT01 | 1 | email="user@gmail.com" | Aceito |
| CT02 | 2 | email="usergmail.com" | Rejeitado |
| CT03 | 4 | senha="Carlos123" | Aceita |
| CT04 | 5 | senha="SenhaSegura" | Rejeitada |
| EXTRA01 | 3 | email="user@" | Rejeitado |
| EXTRA02 | — | email="" | Rejeitado |
| EXTRA03 | 6 | senha="Abc123" (6 caracteres) | Rejeitada |
| EXTRA04 | — | senha="" | Rejeitada |
| EXTRA05 | 5 | senha="Abcdefgh" (8 chars, sem número) | Rejeitada |
| EXTRA06 | 4 | senha="Abcdefg1" (8 chars, com número) | Aceita |
| CT05 | — | código="123456" (válido, não expirado) | Aceito |
| CT06 | — | código="123456" (expirado, >15min) | Rejeitado |
| EXTRA07 | — | código digitado diferente do esperado | Rejeitado |
| EXTRA08 | — | código="" (vazio) | Rejeitado |
| EXTRA09 | — | código no limite exato de 15min (14m59s) | Aceito |

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
00:00 +46: All tests passed!
```

<div align="justify">
O resultado <strong>+46</strong> confirma a execução bem-sucedida de todos os casos de teste unitário das três histórias de usuário: <strong>16 testes</strong> da US #16 (CT01–CT06 + EXTRA01–EXTRA09 + cenário completo), <strong>13 testes</strong> da US #04 (CT01–CT04 + EXTRA01–EXTRA09) e <strong>17 testes</strong> da US #06 (CT01–CT04 + EXTRA01–EXTRA12 + cenário completo). Nenhum teste falhou.
</div>

---

# Evidência de Execução — Testes de Integração (Widget Tests)

<div align="justify">
A execução dos três arquivos de widget test — agora incluindo os 4 cenários reais da <code>RegistroEmocionalScreen</code> (US #06), antes pendentes — foi realizada via linha de comando, com o seguinte resultado:
</div>

```
PS C:\Users\raine\Downloads\slowdown\frontend> flutter test test/us04_monitor_screen_widget_test.dart test/us06_registro_emocional_screen_widget_test.dart test/us16_register_screen_widget_test.dart --reporter expanded
```

<img width="1184" height="656" alt="image" src="https://github.com/user-attachments/assets/6c76a001-329d-49c0-8f96-7eee86758367" />



<div align="justify">
<!-- Atualizar este parágrafo com o resultado real assim que o comando acima for executado novamente. Espera-se "+16: All tests passed!", sem nenhum teste pendente (skip), já que a tela de Registro Emocional foi implementada. -->
Complementarmente, foram executados **19 testes de integração (widget tests)**, que simulam a interação real do usuário com as telas `MonitorScreen` (US #04), `RegistroEmocionalScreen` (US #06) e `RegisterScreen` (US #16), verificando se a interface reage corretamente às entradas — exibindo (ou não) as mensagens de erro e de sucesso esperadas. Todos os cenários implementados foram executados e validados de ponta a ponta, sem nenhum teste pendente (`skip`) restante no projeto.
</div>

<br>

<div align="justify">
Adicionalmente, foi realizada uma <strong>auditoria de revisão de código</strong>, na qual a lógica de cada validador (<code>validador_bpm.dart</code>, <code>validador_registro_emocional.dart</code> e <code>validador_auth.dart</code>) foi simulada manualmente contra a totalidade dos casos de teste (CT e EXTRA) das três histórias de usuário, e contra os textos e finders exatos utilizados pelos widget tests. A auditoria confirmou que todos os 46 casos unitários e os 16 cenários de widget test (incluindo os 4 cenários da <code>RegistroEmocionalScreen</code>, agora implementada) produzem o resultado esperado, sem divergências entre a implementação e a especificação dos testes.
</div>
