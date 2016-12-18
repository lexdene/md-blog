git ls-tree -r HEAD | cut -f 2 | grep '/.*\.md$' | while read line; do
    first_add_time=$(git log --oneline --pretty=format:'%at' --diff-filter=A $line)
    echo $first_add_time $line
done | sort | while read line; do
    path=$(echo $line | cut -d ' ' -f 2)
    title=$(head -1 $path | cut -c 3-)
    echo "* [$title]($path)"
done
