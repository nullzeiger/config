#!/bin/bash

set -e

# Download pre-built binaries of lazygit
wget https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
# Extract the archive
mkdir -p .~/.local/lazygit.app
tar -C ~/.local/lazygit.app -xzf lazygit_0.44.1_Linux_x86_64.tar.gz 
# Create symbolic links to add lazygit to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/lazygit.app/lazygit ~/.local/bin/
# Delete archive
rm -rf lazygit_0.44.1_Linux_x86_64.tar.gz
