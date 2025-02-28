#!/bin/bash

# Run with:
# wget -O /tmp/install-fish-linux.sh https://github.com/nicholas-a-guerra/Tools/raw/refs/heads/main/install-fish-linux.sh && bash /tmp/install-fish-linux.sh
# ** The fish commands attempt to read stdin, so do not attempt to directly pipe wget stdout into bash stdin (this will break things) **

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Fish Shell Installation Script ===${NC}"

# Detect distribution
DISTRO=$(lsb_release -is)
echo -e "${GREEN}Detected distribution: ${DISTRO}${NC}"

if [[ "$DISTRO" == "Debian" ]]; then
    echo -e "${YELLOW}Detecting Debian version...${NC}"
    DEBIAN_VERSION=$(lsb_release -rs)
    echo -e "${GREEN}Detected Debian version: ${DEBIAN_VERSION}${NC}"
    echo -e "\n${YELLOW}Adding Fish repository for Debian...${NC}"
    echo "deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_${DEBIAN_VERSION}/ /" | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
    echo -e "${GREEN}✓ Repository added${NC}"

    echo -e "\n${YELLOW}Adding repository key...${NC}"
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_${DEBIAN_VERSION}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    echo -e "${GREEN}✓ Key added${NC}"
elif [[ "$DISTRO" == "Ubuntu" ]]; then
    echo -e "\n${YELLOW}Adding Fish repository for Ubuntu...${NC}"
    sudo add-apt-repository ppa:fish-shell/release-3 -y
    echo -e "${GREEN}✓ Repository added${NC}"
else
    echo -e "\n${RED}Error: This script only supports Debian and Ubuntu.${NC}"
    echo -e "${RED}Detected distribution: ${DISTRO}${NC}"
    echo -e "${RED}Exiting...${NC}"
    exit 1
fi

echo -e "\n${YELLOW}Updating package lists...${NC}"
sudo apt-get update
echo -e "${GREEN}✓ Package lists updated${NC}"

echo -e "\n${YELLOW}Installing Fish shell...${NC}"
sudo apt-get install fish -y
echo -e "${GREEN}✓ Fish shell installed${NC}"

echo -e "\n${YELLOW}Installing Fisher package manager...${NC}"
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
echo -e "${GREEN}✓ Fisher installed${NC}"

echo -e "\n${YELLOW}Installing Tide prompt...${NC}"
fish -c 'fisher install IlanCosman/tide@v6'
echo -e "${GREEN}✓ Tide installed${NC}"

echo -e "\n${YELLOW}Configuring Tide prompt...${NC}"
# Redirect stdout to /dev/null to prevent terminal clearing
fish -c 'tide configure --auto --style=Rainbow --prompt_colors="16 colors" --show_time="12-hour format" --rainbow_prompt_separators=Round --powerline_prompt_heads=Round --powerline_prompt_tails=Round --powerline_prompt_style="Two lines, character" --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_spacing=Sparse --icons="Many icons" --transient=No' > /dev/null
echo -e "${GREEN}✓ Tide configured${NC}"

echo -e "\n${YELLOW}Installing autopair plugin...${NC}"
fish -c 'fisher install jorgebucaran/autopair.fish'
echo -e "${GREEN}✓ Autopair installed${NC}"

echo -e "\n${YELLOW}Creating Fish configuration file...${NC}"
cat > ~/.config/fish/config.fish << 'EOF'
if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting
bind \ew\x7F backward-kill-line
EOF
echo -e "${GREEN}✓ Configuration file created${NC}"

echo -e "\n${YELLOW}Setting Fish as default shell...${NC}"
sudo usermod -s $(which fish) $(whoami)
echo -e "${GREEN}✓ Fish is now your default shell${NC}"

echo -e "\n${BLUE}=== Installation Complete! ===${NC}"
echo -e "${GREEN}Log out and log back in to start using Fish shell, or run 'fish' to try it now.${NC}"
