#!/bin/bash
# Interactively delete local branches that exist on origin

set -euo pipefail

# Fetch latest remote state
git fetch -p

# Define protected branches
protected_branches="^(main|master|develop|dev)$"

# Loop through local branches
for branch in $(git branch --format "%(refname:short)" | grep -vE "$protected_branches"); do
  if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    read -p "Delete local branch '$branch'? [y/N] " answer
    case "$answer" in
      [yY]|[yY][eE][sS])
        if git branch -d "$branch" 2>/dev/null; then
          echo "✓ Deleted branch: $branch"
        else
          echo "⚠️  Branch '$branch' not fully merged. Forcing delete..."
          git branch -D "$branch"
        fi
        ;;
      *)
        echo "Skipped $branch"
        ;;
    esac
  fi
done
