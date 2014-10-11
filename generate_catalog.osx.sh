first="1"
git ls-tree -r HEAD | cut -f 2 | grep '/.*\.md$' | while read line; do
    # first_add_commit=$(git log --oneline --diff-filter=A $line)
    first_add_time=$(git log --oneline --pretty=format:'%at' --diff-filter=A $line)
    echo $first_add_time $line
done | sort | while read line; do
    if [ $first = "1" ]; then
        first="0"
        echo '# 目录'
        echo ''
    else
        echo ''
    fi

    arr=(${line// / })
    time=${arr[0]}
    path=${arr[1]}
    echo -n '#'
    head -1 $path
    echo ''
    echo "[$path]($path)"
    echo ''
    echo -n '创建时间: '
    date -r $time +"%Y-%m-%d %H:%M:%S"
done

