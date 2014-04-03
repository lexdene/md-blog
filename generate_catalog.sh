first="1"
git ls-tree -r HEAD | cut -f 2 | grep '/.*\.md$' | while read LINE;do
    if [ $first = "1" ]; then
        first="0"
    else
        echo ''
    fi
    echo -n '#'
    head -1 $LINE
    echo ''
    echo "[$LINE]($LINE)"
done
