#!/bin/bash

DEBIAN_VERSION=$(lsb_release -rs)
echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_${DEBIAN_VERSION}/ /" | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_${DEBIAN_VERSION}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
sudo apt update
sudo apt-get install fish -y

fish -c '
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    echo "n" | fisher install IlanCosman/tide@v6
    tide configure --auto --style=Rainbow --prompt_colors="16 colors" --show_time="12-hour format" --rainbow_prompt_separators=Round --powerline_prompt_heads=Round --powerline_prompt_tails=Round --powerline_prompt_style="Two lines, character" --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Sparse --icons="Many icons" --transient=No
    fisher install jorgebucaran/autopair.fish
'

cat > ~/.config/fish/config.fish << 'EOF'
if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting
bind \ew\x7F backward-kill-line
EOF

sudo usermod -s $(which fish) $(whoami)