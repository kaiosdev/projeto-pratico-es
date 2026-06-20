<div align="center">

# 🧪 Projeto de Casos de Teste — SlowDown

*Engenharia de Software A · ICET/UFAM*

![Fase](https://img.shields.io/badge/Fase-Testes_TP3-4a90d9?style=for-the-badge&logo=jest&logoColor=white)
![Técnica](https://img.shields.io/badge/Técnica-Caixa_Preta-2e7d32?style=for-the-badge)

</div>

## 1. Introdução

Este documento apresenta o Projeto de Casos de Teste para o sistema SlowDown, abrangendo as Histórias de Usuário **US-01 a US-04**. 

Os testes foram derivados utilizando a técnica funcional de **Particionamento em Classes de Equivalência**[cite: 5]. Essa técnica divide o domínio de entrada do programa em classes de dados (válidas e inválidas), garantindo que um número reduzido de testes consiga encontrar a maior quantidade de defeitos possível, validando o comportamento do sistema para cada faixa de valores[cite: 5].

---

# US-01 - Sessões de Meditação Guiada

### Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Duração da Sessão | Valor pertence ao conjunto: 5, 10, 15, 20 (1) | Valor fora do conjunto (2) | Valor nulo ou vazio (3) |
| Locutor | Locutor do catálogo selecionado (4) | Nenhum locutor selecionado (5) | — |
| Tipo de Assinatura | Usuário com plano Premium ativo (6) | Usuário com plano Free/Gratuito (7) | Conta não autenticada (8) |

Classes de Equivalência da US-01.

### Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 6 | Duração: 10; Locutor: Voz Serenidade; Plano: Premium | Sessão iniciada com sucesso |
| Caso 2 | 2, 4, 6 | Duração: 7; Locutor: Voz Serenidade; Plano: Premium | Sistema impede início e exibe erro de duração |
| Caso 3 | 3, 4, 6 | Duração: Nulo; Locutor: Voz Serenidade; Plano: Premium | Sistema impede início por campo obrigatório ausente |
| Caso 4 | 1, 5, 6 | Duração: 10; Locutor: Nulo; Plano: Premium | Sistema solicita seleção obrigatória do locutor |
| Caso 5 | 1, 4, 7 | Duração: 10; Locutor: Voz Serenidade; Plano: Free | Sistema bloqueia acesso e exibe paywall do Premium |

Casos de Teste da US-01.

<br>

# US-02 - Playlists de Relaxamento Offline

### Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Espaço de Armazenamento | Espaço livre igual ou maior que o tamanho do arquivo (1) | Espaço livre menor que o tamanho do arquivo (2) | — |
| Estado da Conexão | Conectado à Internet (Wi-Fi ou Dados) (3) | Sem conexão / Modo Avião (4) | — |

Classes de Equivalência da US-02.

### Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 3 | Arquivo: 50MB; Espaço: 2000MB; Rede: Conectada | Download autorizado e playlist salva na seção Offline |
| Caso 2 | 2, 3 | Arquivo: 50MB; Espaço: 10MB; Rede: Conectada | Download bloqueado e sistema alerta espaço insuficiente |
| Caso 3 | 1, 4 | Arquivo: 50MB; Espaço: 2000MB; Rede: Offline | Sistema bloqueia tentativa e solicita conexão com a internet |

Casos de Teste da US-02.

<br>

# US-03 - Pet Virtual Inclusivo

### Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Tempo desde a última alteração | Tempo igual ou superior a 7 dias (1) | Tempo inferior a 7 dias (2) | — |
| Nome do Pet | Texto contendo de 1 a 20 caracteres (3) | Campo obrigatório ausente/vazio (4) | Texto com mais de 20 caracteres (5) |
| Manutenção de Felicidade | Login realizado em 48 horas ou menos (6) | Inatividade superior a 48 horas (7) | — |

Classes de Equivalência da US-03.

### Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 3, 6 | Tempo: 8 dias; Nome: Buddy; Inatividade: 24h | Nome alterado com sucesso e felicidade mantida |
| Caso 2 | 2, 3, 6 | Tempo: 3 dias; Nome: Buddy; Inatividade: 24h | Sistema impede alteração devido a período de carência |
| Caso 3 | 1, 4, 6 | Tempo: 8 dias; Nome: Vazio; Inatividade: 24h | Sistema impede salvamento por campo em branco |
| Caso 4 | 1, 5, 6 | Tempo: 8 dias; Nome: TextoLongo; Inatividade: 24h | Sistema impede salvamento por limite de caracteres |
| Caso 5 | 1, 3, 7 | Tempo: 8 dias; Nome: Buddy; Inatividade: 50h | Nome alterado com sucesso, mas Pet perde 1 nível de felicidade |

Casos de Teste da US-03.

<br>

# US-04 - Monitoramento Cardíaco

### Tabela de Classes de Equivalência

| Condição de Entrada | Classes Válidas | Classes Inválidas | Classes Inválidas |
| :--- | :--- | :--- | :--- |
| Frequência Cardíaca (BPM) | Batimentos entre 60 e 100 BPM (1) | Batimentos abaixo de 60 BPM (2) | Batimentos acima de 100 BPM (3) |
| Intervalo de Amostragem | Tempo configurado igual ou maior que 600s (4) | Tempo configurado menor que 600s (5) | Valor de tempo nulo ou negativo (6) |
| Permissão do Sistema (SO) | Acesso aos sensores de saúde concedido (7) | Acesso aos sensores negado/revogado (8) | — |

Classes de Equivalência da US-04.

### Tabela de Casos de Teste

| Casos de Teste | Classes de Equivalência | Entradas | Resultado Esperado |
| :--- | :--- | :--- | :--- |
| Caso 1 | 1, 4, 7 | BPM: 85; Intervalo: 600s; Sensor: Permitido | Registro salvo normalmente; nenhum alerta disparado |
| Caso 2 | 2, 4, 7 | BPM: 45; Intervalo: 600s; Sensor: Permitido | Sistema dispara notificação de alerta de repouso crítico |
| Caso 3 | 3, 4, 7 | BPM: 115; Intervalo: 600s; Sensor: Permitido | Sistema dispara notificação de alerta de taquicardia |
| Caso 4 | 1, 5, 7 | BPM: 85; Intervalo: 30s; Sensor: Permitido | Sistema rejeita configuração para prevenir dreno de bateria |
| Caso 5 | 1, 6, 7 | BPM: 85; Intervalo: -10s; Sensor: Permitido | Sistema exibe erro de formato de tempo inválido |
| Caso 6 | 1, 4, 8 | BPM: 85; Intervalo: 600s; Sensor: Negado | Sistema suspende monitoramento e solicita permissão nas configurações |

Casos de Teste da US-04.
