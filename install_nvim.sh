#!/bin/bash

set -e

# Download pre-built binaries of neovim
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
# Extract the archive
tar -C ~/.local -xzf nvim-linux64.tar.gz
# Rename to nvim.app
mv ~/.local/nvim-linux64 ~/.local/nvim.app
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/nvim.app/bin/nvim ~/.local/bin/
# Delete archive
rm -rf nvim-linux64.tar.gz
