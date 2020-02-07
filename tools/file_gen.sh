#!/usr/bin/env bash
# First args to specific file name and the second specific the size.
# e.g. ./file_gen.sh a.out 51200
# Then a 50MB file would be create
dd if=/dev/zero of=$1 bs=1024 count=$2