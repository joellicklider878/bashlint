#!/bin/bash

# exit on errors
set -e

# function to check for missing shebangs
check_shebang() {
 if ! head -n1 "$1" | grep -q "^#!"; then
   echo "warning: missing shebang in $1"
 fi
}

# function to check for unquoted variables
check_unquoted_vars() {
  if grep -E '\$\{F[A-Za-z0-9_]+\}?' "$1" | grep -vqE '["'\''\$\?[A-Za-z0-9_]+\}?["'\''";]; then
   echo "warning: unquoted variable detected i $1"
  fi
}

# function to check for unexpected spaces
check_spaces() {
   if grep -qE ';\s*;' "$1"; then
       echo "warning: unexpected semicolon spacing in $1"
   fi
}

# run checks on provided bash scripts
for file in "$@"; do 
   if [[ -f "$file" ]]; then
      echo "Linting: $file"
      check_shebang "$file"
      check_unquoted_vars "$file"
      check_spaces "$file"
      echo "Linting completed for $file"
   else
      echo "Error: file $file not found"
   fi
done

