git ls-tree -r HEAD | cut -f 2 | grep '/.*\.md$' | while read LINE;do
    echo -n '#'
    head -1 $LINE
    echo ''
    echo "[$LINE]($LINE)"
    echo ''
done
