# ai-frame

Playground pour chaîner des LLM et des agents en pipes shell, basé sur [`llm`](https://llm.datasette.io).
Chaque étape lit stdin et écrit stdout, donc on compose avec `|`.

Testé sur macOS (Homebrew) et Arch Linux (pacman).

## Démarrage

```sh
git clone <repo> ai-frame && cd ai-frame
./play setup          # installe uv, jq, ollama si absents, puis les deps Python et le modèle local
$EDITOR .env          # ANTHROPIC_API_KEY, JEFF_API_KEY...
echo "Faut-il migrer la CI ?" | ./play flow decide
```

Ollama doit tourner pour que le setup tire le modèle local (`ollama serve`, ou le service systemd sur Arch).

## Commandes

| Commande | Effet |
|---|---|
| `./play setup` | installe ce qui manque, idempotent |
| `./play flows` | liste les flows |
| `./play flow <nom>` | lance `flows/<nom>.sh` |
| `./play llm ...` | n'importe quelle commande `llm` dans l'env du projet |
| `./play llm models` | modèles dispo (Claude : `claude-sonnet-5.5`, local : `ollama/llama3.2`) |
| `./play llm logs -n 3` | dernières réponses loggées (`.llm/logs.db`) |

## Ajouter un flow

Créer `flows/<nom>.sh`, le rendre exécutable. `llm`, `jeff` et tout ce qu'il y a dans `bin/` sont dans le PATH.

```sh
#!/usr/bin/env bash
set -euo pipefail
llm -m claude-sonnet-5.5 -s "Extrait les faits." | llm -m ollama/llama3.2 -s "Résume en 2 lignes."
```

## Ajouter un outil

Un script dans `bin/` qui lit stdin et écrit stdout. Voir `bin/jeff` : wrapper de `POST /v1/decide`
sur [jeffhub.ai](https://jeffhub.ai/docs/guides/quickstart), avec une réponse factice tant que `JEFF_API_KEY`
est vide. La fonction appelée vient de `JEFF_FUNCTION`.

Pour un autre provider LLM, ajouter son plugin dans `pyproject.toml` (`llm-gemini`, `llm-mistral`...) puis `./play setup`.
