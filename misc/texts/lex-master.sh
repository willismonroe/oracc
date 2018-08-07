#!/bin/sh
type=$1
if [ "$type" == "" ]; then
    echo 'lex-master.sh: must give type, e.g., sign'
    exit 1
fi
echo "<lex:dataset xmlns:xi=\"http://www.w3.org/2001/XInclude\" xmlns:lex=\"http://oracc.org/ns/lex/1.0\">" \
     >01tmp/lex/lex-$type-master.xml
cd 01tmp/lex
for a in `find $type -type f` ; do
    xi="<xi:include href=\"$a\"/>"
    echo $xi >>lex-$type-master.xml
done
cd ../..
echo '</lex:dataset>' >>01tmp/lex/lex-$type-master.xml
