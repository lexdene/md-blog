git config --global user.name "Elephant Liu"

git config --global color.branch "auto"
git config --global color.ui "auto"
git config --global color.status "auto"

git config --global alias.st "status"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
git config --global alias.ci "commit"
git config --global alias.cia "commit --amend"
git config --global alias.ciah "commit --amend -C HEAD" # 修改commit内容但不修改commit信息
git config --global alias.cich "commit -c HEAD"
git config --global alias.co "checkout"
git config --global alias.cob "checkout -b"
git config --global alias.coa "checkout -- '*'"
git config --global alias.ps "push"
git config --global alias.psu "push -u"
git config --global alias.psf "push -f"
git config --global alias.pl "pull"
git config --global alias.fc "fetch"
git config --global alias.fca "fetch --all"
git config --global alias.ap "add -p"
git config --global alias.an "add -N"
git config --global alias.df "diff"
git config --global alias.dfc "diff --cached"
git config --global alias.dtr "diff-tree --no-commit-id --name-only -r" # 很久以前加的，现在不记得是什么意思了
git config --global alias.dst "diff --name-status" # 使用一种类似于SVN的格式来输出diff
git config --global alias.ffm "merge --ff-only"
git config --global alias.nem "merge --no-edit"
git config --global alias.rs "reset"
git config --global alias.rsh "reset --hard"
git config --global alias.rshp "reset --hard HEAD^"
git config --global alias.rss "reset --soft"

git config --global core.editor "emacs"

git config --global push.default current

git config --global mergetool.keepBackup false
