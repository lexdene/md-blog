# git commit with current branch name as message and edit
git commit -m "$(git rev-parse --abbrev-ref HEAD):" -e
