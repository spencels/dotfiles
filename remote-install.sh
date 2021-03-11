#!/bin/bash
# "Remote install" script meant to be piped directly to bash.

function main {
  local working_dir=`mkdtemp -d`

  git clone https://github.com/spencels/dotfiles.git "$working_dir"

  echo "Installing files..."
  "$working_dir/install.sh"
  echo "Cleaning up."
  rm "$working_dir"
}
main
