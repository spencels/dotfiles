#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cp "$script_dir/.bashrc" "$HOME"
cp "$script_dir/.bash_profile" "$HOME"
