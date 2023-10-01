# bin/bash
# termux_theme
# Define ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function error_exit {
  echo -e "${RED}Error: $1${NC}" >&2
  #exit 1
}

# Set Up Storage
termux-setup-storage

# pkgs
apt update && apt upgrade -y
apt update && apt install nala -y
nala install zsh python wget gh python-pip lazygit stylua luarocks luajit ripgrep fd gettext neovim nodejs git micro openssh zip curl ruby timewarrior taskwarrior htop figlet termux-api composer logo-ls lsd -y || error_exit "${RED}Failed to install packages.${NC}"
nala install golang php rust openjdk-17 
python -m ensurepip --default-pip
apt-get install fish -y
npm install -g vscode-json-languageserver
#pkg install stylua 
#cargo install stylua


# font
  cd ~/.termux
  if [ ! -e font.ttf ]; then
    printf "\n   💠 ${YELLOW}Downloading font${NC}\n\n"
    cd $HOME
    git clone https://github.com/tharindu899/x-theme
    mv ~/x-theme/font.ttf ~/.termux
    rm -rf ~/x-theme
    termux-reload-settings
    #wget https://raw.githubusercontent.com/rooted-cyber/good/master/zsh/font.ttf
    printf "\n   💠 ${GREEN}Successfully downloaded font.ttf${NC}\n"
  else
    printf "\n   💠 ${RED}already exists font.ttf${NC}\n"
  fi
  
# Install pynvim, pnpm and neovim npm package, and neovim gem package
echo -e "\n   📌 ${GREEN}install gems update${NC}\n"
gem update --system || error_exit "${RED}Failed to update gem.${NC}"
echo -e "\n   📌 ${GREEN}install gems${NC}\n"
gem install lolcat || error_exit "${RED}Failed to install lolcat${NC}"
echo -e "\n   📌 ${GREEN}install python-pip${NC}\n"
python -m pip install pynvim || error_exit "${RED}Failed to install pynvim.${NC}"
echo -e "\n   📌 ${GREEN}install pnpm neovim${NC}\n"
npm install -g pnpm neovim || error_exit "${RED}Failed to install neovim npm package.${NC}"
echo -e "\n   📌 ${GREEN}install gems neovim${NC}\n"
gem install neovim || error_exit "${RED}Failed to install neovim gem package.${NC}"
echo -e "\n   📌 ${GREEN}install npm fund${NC}\n"
npm fund
clear
# termux_theme
# Install Oh My Zsh plugins
echo -e "\n${GREEN}Installing Zsh Plugins${NC}"

# ohmyzsh
  cd ~
  if [ -e .oh-my-zsh ]; then
    printf "\n   💠 ${RED}Already installed oh-my-zsh${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning oh-my-zsh${NC}\n\n"
    cd ~
    git clone https://github.com/ohmyzsh/ohmyzsh
    mv ohmyzsh .oh-my-zsh
    printf "\n   💠 ${GREEN}Cloning successful oh-my-zsh ${NC}\n"
  fi

# power
  cd ~
  if [ -e powerlevel10k ]; then
    printf "\n   💠 ${RED}Already installed powerlevel10k${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning powerlevel10k${NC}\n\n"
    cd ~
    git clone https://github.com/romkatv/powerlevel10k
    printf "\n   💠 ${GREEN}Cloning successful powerlevel10k ${NC}\n"
  fi
  
# Completions
  cd $HOME/.oh-my-zsh/plugins
  if [ -e zsh-completions ]; then
    printf "\n   💠 ${RED}Already installed zsh-completions${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning zsh-completions${NC}\n\n"
    cd $HOME/.oh-my-zsh/plugins
    git clone https://github.com/zsh-users/zsh-completions
    printf "\n   💠 ${GREEN}Cloning successful zsh-completions${NC}\n"
  fi

# History Substring Search
  cd $HOME/.oh-my-zsh/plugins
  if [ -e zsh-history-substring-search ]; then
    printf "\n   💠 ${RED}Already installed zsh-history-substring-search${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning zsh-history-substring-search${NC}\n\n"
    cd $HOME/.oh-my-zsh/plugins
    git clone https://github.com/zsh-users/zsh-history-substring-search
    printf "\n   💠 ${GREEN}Cloning successful zsh-history-substring-search${NC}\n"
  fi

# Git Flow Completions
  cd $HOME/.oh-my-zsh/plugins
  if [ -e git-flow-completion ]; then
    printf "\n   💠 ${RED}Already installed git-flow-completion${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning git-flow-completion${NC}\n\n"
    cd $HOME/.oh-my-zsh/plugins
    git clone https://github.com/bobthecow/git-flow-completion
    printf "\n   💠 ${GREEN}Cloning successful git-flow-completion${NC}\n"
  fi

# Zsh Vi Mode
  cd $HOME/.oh-my-zsh/plugins
  if [ -e zsh-vi-mode ]; then
    printf "\n   💠 ${RED}Already installed zsh-vi-mode${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning zsh-vi-mode${NC}\n\n"
    cd $HOME/.oh-my-zsh/plugins
    git clone https://github.com/jeffreytse/zsh-vi-mode
    printf "\n   💠 ${GREEN}Cloning successful zsh-vi-mode${NC}\n"
  fi

# Magic Enter
  cd $HOME/.oh-my-zsh/plugins
  if [ -e magic-enter ]; then
    printf "\n   💠 ${RED}Already installed magic-enter${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Cloning magic-enter${NC}\n\n"
    cd $HOME/.oh-my-zsh/plugins
    git clone https://github.com/GR3YH4TT3R93/magic-enter
    printf "\n   💠 ${GREEN}Cloning successful magic-enter${NC}\n"
  fi

# add alias
  cd ~/.termux
  if [ ! -e add.sh ]; then
    printf "\n   💠 ${YELLOW}Downloading add.sh${NC}\n\n"
    wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/add.sh
    printf "\n   💠 ${GREEN}Successfully downloaded add.sh${NC}\n"
  else
    printf "\n   💠 ${RED}already exists add.sh${NC}\n"
  fi

# highlighting
  cd $PREFIX/etc
  if [ -e .plugin ]; then
    printf "\n   💠 ${RED}Already exists syntax-highlighting${NC}\n"
  else
    printf "\n   💠 ${YELLOW}cloning syntax-highlighting${NC}\n\n"
    cd $PREFIX/etc
    mkdir .plugin
    cd .plugin
    git clone https://github.com/zsh-users/zsh-syntax-highlighting #> /dev/null 2>&1
    printf "\n   💠 ${GREEN}Cloning successful${NC}\n"
  fi

# suggestions
  cd $PREFIX/etc/.plugin
  if [ -e zsh-autosuggestions ]; then
    printf "\n   💠 ${RED}Already exists autosuggestions${NC}\n"
  else
    printf "\n   💠 ${YELLOW}cloning autosuggestions${NC}\n\n"
    cd $PREFIX/etc/.plugin
    git clone https://github.com/zsh-users/zsh-autosuggestions #> /dev/null 2>&1
    printf "\n   💠 ${GREEN}Cloning successful${NC}\n"
  fi

# banner
  cd $PREFIX/etc
  if [ ! -e rxfetch ]; then
    printf "\n   💠 ${YELLOW}Downloading banner.txt${NC}\n\n"
    cd $PREFIX/etc
    #wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/banner.txt
    wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/rxfetch
    printf "\n   💠 ${GREEN}Successfully added banner${NC}\n"
  else
    printf "\n   💠 ${RED}already exists banner${NC}\n"
  fi

# etc
  cd $PREFIX/etc
  if [ -e motd1 ]; then
    printf "\n   💠 ${RED}Already installed motd${NC}\n"
  else
    printf "\n   💠 ${YELLOW}Downloading banner zshrc${NC}\n\n"
    mv motd motd1
    rm -rf zshrc
    wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/zshrc
    printf "   💠 ${GREEN}Successfully added zshrc${NC}\n\n"
  fi
  
# .zshrc
  cd ~
  printf "\n   💠 ${YELLOW}Downloading .zshrc${NC}\n\n"
  rm -rf .zshrc
  wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/.zshrc 
  printf "\n   💠 ${GREEN}Download Complete .zshrc${NC}\n\n"

# p10k.sh
  cd ~
  printf "\n   💠 ${YELLOW}Downloading .p10k.zsh${NC}\n\n"
  rm -rf .p10k.zsh
  wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/.p10k.zsh 
  printf "\n   💠 ${YELLOW}Download Complete .p10k.zsh${NC}\n\n"


# button
  cd ~/.termux
  if [ -e .termux ]; then
    cd ~/.termux
    mv termux.properties termux.properties1
    printf "\n\n    💠 ${YELLOW}Downloading button file${NC}\n\n"
    wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/termux.properties
    printf "\n    💠 ${GREEN}Downloading complete${NC}"
  else
    mv termux.properties termux.properties1
    printf "\n\n    💠 ${YELLOW}Downloading button file${NC}\n\n"
    wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/termux.properties
  fi
  
# colour
  cd "$HOME/.termux" || exit
  if [ -e colour ]; then
    printf "\n   💠 ${RED}Already exists colour dir${NC}\n\n"
  else
    printf "\n   💠 ${YELLOW}Create colour dir${NC}\n\n"
    mkdir colour
    if [ -e colors.properties ]; then
      mv "colors.properties" "$HOME/.termux/colour/.colors.properties.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
    echo "#!colors colors.properties" >> colors.properties
    echo "background=#120321" >> colors.properties
    printf "\n   💠 ${GREEN}Create Successfully${NC}\n\n"
  fi

# exit_command  
cd $PREFIX/bin
  rm -rf e
  echo "#!/data/data/com.termux/files/usr/bin/sh" >> e
  echo "killall -9 com.termux" >> e
  chmod 777 e

# acode-X sever
  echo -e "${YELLOW}acode-X installServer${NC}"
  curl -sL https://raw.githubusercontent.com/bajrangCoder/acode-plugin-acodex/main/installServer.sh | bash

# shortcurs_command
 cd $PREFIX/bin
  rm -rf add
  echo "#!/data/data/com.termux/files/usr/bin/sh" >> add
  echo "bash ~/.termux/add.sh" >> add
  chmod 777 add
  
# defult set zsh command
  chsh -s zsh
  
# AstroNvim install
  cd $HOME
  if [ -e .config ]; then
    printf "\n${YELLOW} backup nvim config & Cloning${NC}\n\n"
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    git clone --depth 1 https://github.com/tharindu899/starter ~/.config/nvim
    nvim
    printf "\n${GREEN} Successfully backup & Cloning${NC}\n\n"
  else
    printf "\n${YELLOW} Cloning AstroNvim${NC}\n\n"  
    cd $HOME
    mkdir .config
    git clone --depth 1 https://github.com/tharindu899/starter ~/.config/nvim
    nvim
    printf "\n${GREEN} Cloning Successfully${NC}\n\n"
  fi
# 