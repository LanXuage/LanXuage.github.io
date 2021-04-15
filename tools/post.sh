#!/bin/sh
post_name=$1
author="LanXuage"
temp="---\ntitle: $post_name\nauthor: $author\ndate: `date '+%Y-%m-%d %T'` +0800\ncategories: []\ntags: []\n---"
p=$2
if [ ! -n "$p" ]; then
    p=`pwd`
fi
e="`date '+%Y-%m-%d-'`$post_name"
echo $temp > "$p/`echo $e|sed 's/ /_/g'`.md"
