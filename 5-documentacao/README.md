# 📄 Documentação do Sistema — SlowDown

| Arquivo | Conteúdo |
| :--- | :--- |
| [`documentacao-slowdown-v2.0.pdf`](documentacao-slowdown-v2.0.pdf) | Documentação completa: introdução, requisitos, regras de negócio, diagramas UML, arquitetura, padrões de projeto e prototipação. |
| [`diagramas/`](diagramas) | Código-fonte dos diagramas UML em PlantUML (`.puml`) e imagens geradas (`.png`). |

Para regenerar um diagrama após alterar o `.puml`:

```bash
java -jar plantuml.jar -tpng diagramas/seq2_login.puml
```

Sempre que uma mudança de código alterar uma regra, tela ou fluxo, atualize o diagrama e o PDF na mesma feature.
