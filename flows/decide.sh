#!/usr/bin/env bash
# Claude analyse -> Jeff décide -> modèle local reformule.
# Usage : echo "Faut-il migrer la CI vers GitLab components ?" | ./play flow decide
set -euo pipefail

llm -m "${CLAUDE_MODEL:-claude-sonnet-5.5}" \
    -s "Analyse la demande. Liste les options possibles et les critères de choix. Sois concis." \
  | jeff \
  | llm -m "ollama/${LOCAL_MODEL:-llama3.2}" \
    -s "Reformule cette décision en 3 lignes claires, en français."
