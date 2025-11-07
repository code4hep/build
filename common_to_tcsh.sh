#!/bin/bash

source common.sh
vars=$(sed -nE "s/^\s*export\s+([A-Za-z_][A-Za-z0-9_]*)=.*/\1/p" common.sh)
for v in $vars; do
	val=${!v}
	printf "setenv %s '%s';\n" "$v" "$val"
done
