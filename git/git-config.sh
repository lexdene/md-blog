git config --global user.name "Elephant Liu"
git config --global user.email "lexdene at sohu dot com"

git config --global color.branch "auto"
git config --global color.ui "auto"
git config --global color.status "auto"

git config --global alias.st "status"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
git config --global alias.ci "commit"
git config --global alias.cia "commit --amend"
# 修改commit内容但不修改commit信息
git config --global alias.ciah "commit --amend -C HEAD"
git config --global alias.co "checkout"
git config --global alias.ps "push"
git config --global alias.pl "pull"
git config --global alias.fa "fetch --all"
git config --global alias.ap "add -p"
git config --global alias.dtr "diff-tree --no-commit-id --name-only -r"
git config --global alias.dst "diff --name-status"
git config --global alias.ffm "merge --ff-only"
git config --global alias.nem "merge --no-edit"

git config --global core.editor "emacs"

git config --global push.default current

git config --global mergetool.keepBackup false
