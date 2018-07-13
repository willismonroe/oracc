#!/bin/sh
for a in $ORACC_BUILDS/www/srv/*.tar.gz ; do
    sec=`stat -c %Y $a`
    prj=`basename $a .tar.gz`
    prj=`/bin/echo -n $prj | tr - /`
    echo "$prj	$sec"
done
