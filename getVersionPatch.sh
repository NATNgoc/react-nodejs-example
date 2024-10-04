#!/bin/bash
PATH=$1

cat $PATH | grep '\"version\":' | head -1 | awk -F '\"' '{print $4}'
