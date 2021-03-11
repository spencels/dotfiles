#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cp "$script_dir/.bashrc" "$HOME"
cp "$script_dir/.bash_profile" "$HOME"
cp "$script_dir/.vimrc" "$HOME"

# Byobu
mkdir -p ~/.byobu
cp "$script_dir/prompt" "$HOME/.byobu/prompt"
