#!/bin/sh

ls *.png | texpack -t -P -e -p 2 -o out/atlas

cp out/* ../../src/
