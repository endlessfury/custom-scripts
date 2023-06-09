#!/bin/bash

old_dir=$1
new_dir=$2

find $old_dir -type f -exec md5sum {} \; | sort -k 2 | sed "s/$old_dir\///g" > ./${old_dir}_md5.txt
find $new_dir -type f -exec md5sum {} \; | sort -k 2 | sed "s/$new_dir\///g" > ./${new_dir}_md5.txt

diff ${old_dir}_md5.txt ${new_dir}_md5.txt
rm -f ${old_dir}_md5.txt ${new_dir}_md5.txt
