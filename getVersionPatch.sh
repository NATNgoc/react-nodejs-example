#!/bin/bash
FILE_PATH=$1

cat $FILE_PATH | grep '\"version\":' | head -1 | awk -F '\"' '{print $4}'
