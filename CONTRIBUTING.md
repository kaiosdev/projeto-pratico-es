# Como contribuir — SlowDown

Guia de gerência de configuração da equipe. Vale para código **e** documentação.

## 1. Branches (Git Flow)

| Branch | Para que serve | Recebe merge de |
| :--- | :--- | :--- |
| `main` | Versão entregue. Cada entrega vira uma tag (`v1.0.0`, `v1.1.0`...). | `release` (Pull Request) |
| `release` | Homologação da próxima entrega. | `development` (Pull Request) |
| `development` | Integração das funcionalidades em andamento. | `feature/*` (Pull Request) |
| `feature/<nome>` | Uma mudança isolada. Apague depois do merge. | — |

> A antiga branch `develop` foi substituída por `development`, seguindo o fluxo da disciplina.

Nunca faça commit direto em `main`, `release` ou `development`, nem edite arquivos pelo site do GitHub nessas branches.

## 2. Passo a passo de uma mudança

```bash
git checkout development
git pull origin development
git checkout -b feature/nome-da-mudanca

# ... edite os arquivos ...
git status
git add <arquivos>
git commit -m ":sparkles: feat(escopo): descrição curta"

git push -u origin feature/nome-da-mudanca
```

Depois, no GitHub: **Compare & pull request** → base `development` → preencha o modelo → aguarde o teste de conflito → **Merge pull request** → **Delete branch**.

Para entregar: Pull Request `development → release`, depois `release → main`, e crie a tag:

```bash
git checkout main && git pull origin main
git tag -a v1.0.0 -m "Entrega final do MVP"
git push origin v1.0.0
```

## 3. Commits semânticos

Formato: `:emoji: tipo(escopo): descrição no imperativo` — curto, descritivo, um assunto por commit
(padrão de <https://github.com/iuricode/padroes-de-commits>).

| Emoji | Tipo | Quando usar |
| :--- | :--- | :--- |
| `:sparkles:` ✨ | `feat` | nova funcionalidade |
| `:bug:` 🐛 | `fix` | correção de erro |
| `:books:` 📚 / `:memo:` 📝 | `docs` | documentação |
| `:recycle:` ♻️ | `refactor` | refatoração sem mudar comportamento |
| `:test_tube:` 🧪 | `test` | testes |
| `:lipstick:` 💄 | `style` | estilo/visual |
| `:wrench:` 🔧 | `chore` | configuração, dependências |
| `:see_no_evil:` 🙈 | `chore` | `.gitignore` |
| `:bookmark:` 🔖 | `release` | nova versão/tag |

✅ `:bug: fix(menu): encerra sessão do Firebase ao sair do app`
❌ `Update menu_screen.dart` · ❌ `alterações` · ❌ `novas telas.`

## 4. O que nunca vai para o repositório

Credenciais (`.env`, `firebase-service-account.json`, chaves `.pem/.jks`) e arquivos gerados
(`node_modules/`, `build/`, `.dart_tool/`). Tudo isso já está no `.gitignore`. Confira com `git status --ignored`.

## 5. Antes de abrir o Pull Request

- `flutter test` passando (pasta `4-MVP/mvp/frontend`);
- app abre com `flutter run` e a tela alterada funciona;
- se mudou regra, tela ou fluxo, atualize a documentação em `5-documentacao/`.
