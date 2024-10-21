#!/bin/bash
#pkg install ncurses-utils -y #--yes > /dev/null 2>> "$ERROR_LOG"
#termux-reload-settings
# Define the error log location
ERROR_LOG="$HOME/skip_errors.log"

# Function to handle errors and log them
log_error() {
    local task="$1"
    local error_msg="$2"
    echo -e "[ERROR] Task: $task | Error: $error_msg" >> "$ERROR_LOG"
}

#
right_align() {
    local task="$1"
    local status="$2"
    local cols=${COLUMNS:-80}  # Use COLUMNS, default to 80 if unavailable
    local task_length=30  # Fixed length for task descriptions
    local padding=$((cols - task_length - 25))  # Adjust the padding for better alignment
    local task_color="\033[1;33m"  # Yellow for task description
    local status_color="\033[1;32m"  # Green for status message (e.g., Done)
    local reset_color="\033[0m"  # Reset to default color

    if [[ "$status" == *"Failed"* ]]; then
        status_color="\033[1;31m"  # Red for failed status
    elif [[ "$status" == *"Exists"* ]]; then
        status_color="\033[1;34m"  # Blue for exists status
    fi

    printf "\r[*] ${task_color}%-${task_length}s${reset_color} : ${status_color}%s${reset_color}" "$task" "$status"
}

# Spinner function for long-running tasks
spin() {
    local pid=$1
    local task="$2"
    local delay=0.25
    local spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
    local success_msg="[ ✓ Done ]"
    local fail_msg="[ ✗ Failed ]"

    while ps -p $pid > /dev/null; do
        for i in "${spinner[@]}"; do
            right_align "$task" "[ ${i} ]"
            sleep $delay
        done
    done

    wait $pid
    if [ $? -eq 0 ]; then
        right_align "$task" "$success_msg"
    else
        right_align "$task" "$fail_msg"
        log_error "$task" "$fail_msg"
        return 1
    fi

    # New line after task completion for better readability
    echo
}

# Function to check existence of a file or directory
check_exist() {
    local item="$1"
    local task="$2"
    local exist_msg="[ Exists ]"

    if [ -e "$item" ]; then
        right_align "$task" "$exist_msg"
        echo  # Move to a new line for the next output
        return 0
    fi
    return 1
}

# Declare the associative array of links
declare -A LINKS=(
    ["x_theme_repo"]="https://github.com/tharindu899/x-theme"
    ["termux_properties"]="https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/termux.properties"
    ["rxfetch"]="https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/rxfetch"
    ["zshrc"]="https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/zshrc"
    ["add_sh"]="https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/add.sh"
    ["oh_my_zsh"]="https://github.com/ohmyzsh/ohmyzsh"
    ["powerlevel10k"]="https://github.com/romkatv/powerlevel10k"
    ["git_flow_completion"]="https://github.com/bobthecow/git-flow-completion"
    ["zsh_completions"]="https://github.com/zsh-users/zsh-completions"
    ["zsh_history_substring_search"]="https://github.com/zsh-users/zsh-history-substring-search"
    ["zsh_syntax_highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
    ["zsh_autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    [".zshrc"]="https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/.zshrc"
    ["p10k_zsh"]="https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/.p10k.zsh"
    ["nvimasro"]="https://github.com/tharindu899/addon/raw/refs/heads/main/termux/nvimasro.zip"
)

clear

# Define the single color (e.g., Cyan)
COLOR='\033[0;36m'

# Function to print the ASCII art in the chosen color
print_single_color() {
    local line="$1"
    echo -e "${COLOR}${line}\033[0m"  # Apply color and reset after each line
}
# Single color ASCII Art Header
echo -e "\n" 
cat << "EOF" > temp_art.txt
    ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
    ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
       ██║   ███████║█████╗  ██╔████╔██║█████╗   
       ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
       ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
       ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝
EOF
# Read and print each line in radiant color
while IFS= read -r line; do
    print_single_color "$line"
done < temp_art.txt
echo -e "\n\n" 
echo -e "\e[1;33m[#] \e[31mIT WILL TAKE \e[34m(\e[32m20\e[30m-\e[32m30.min\e[34m)\e[31m INSTALLING \e[33m[#]\e[0m\n"
#pkg install ncurses-utils -y > /dev/null 2>> "$ERROR_LOG" &
#echo -e "\e[31mtput package\e"

echo -e "\033[33m\r[*] \033[4;32mChecking Your Internet Connection... \e[0m"; 
(ping -c 3 google.com) &> /dev/null 2>&1
if [[ "$?" != 0 ]];then
    echo -e "\033[31m\r[*] \033[4;32mPlease Check Your Internet Connection... \e[0m"; 
    sleep 1
    exit 0
fi
echo -e "\n\n" 

# Update and install necessary packages
(apt-get update --yes && apt-get upgrade --yes) > /dev/null 2>> "$ERROR_LOG" &
spin $! "upgrading packages"

# Install necessary packages
pkg install git -y > /dev/null 2>> "$ERROR_LOG" &
spin $! "git"

# Clone the x-theme repository if it doesn't already exist
check_exist "$HOME/x-theme" "Font"
if [ ! -d "$HOME/x-theme" ]; then
    git clone "${LINKS[x_theme_repo]}" "$HOME/x-theme" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "Font"
fi

# Move font if it exists
if [ -f "$HOME/x-theme/font.ttf" ]; then
    mv "$HOME/x-theme/font.ttf" "$HOME/.termux"
    rm -rf "$HOME/x-theme"
    termux-reload-settings
fi
# Install nala
(apt-get install nala -y) > /dev/null 2>> "$ERROR_LOG" &
spin $! "Installing nala"

# Install additional necessary packages
pkg install zsh bc python wget gh python-pip micro openssh zip curl figlet logo-ls lsd -y > /dev/null 2>> "$ERROR_LOG" &
spin $! "packages"

# Setup color directory
check_exist "$HOME/.termux/colour" "Color directory"
if [ ! -d "$HOME/.termux/colour" ]; then
    mkdir "$HOME/.termux/colour"
    if [ -e "$HOME/.termux/colors.properties" ]; then
        mv "$HOME/.termux/colors.properties" "$HOME/.termux/colour/.colors.properties.bak.$(date +%Y.%m.%d-%H:%M:%S)"
    fi
    echo "#!colors colors.properties" > "$HOME/.termux/colors.properties"
    echo "background=#120321" >> "$HOME/.termux/colors.properties"
fi

# Download termux.properties
if [ -e "$HOME/.termux/termux.properties" ]; then
    rm "$HOME/.termux/termux.properties"
fi
wget "${LINKS[termux_properties]}" -O "$HOME/.termux/termux.properties" > /dev/null 2>> "$ERROR_LOG" &
spin $! "termux.properties"
termux-reload-settings

# Download rxfetch if it doesn't exist
#check_exist "$PREFIX/etc/rxfetch" "rxfetch exists"
if [ ! -d "$PREFIX/etc/rxfetch" ]; then
    wget "${LINKS[rxfetch]}" -O "$PREFIX/etc/rxfetch" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "rxfetch"
fi

# Download zshrc
check_exist "$PREFIX/etc/motd1" "motd1 "
if [ ! -e "$PREFIX/etc/motd1" ]; then
    if [ -e "$PREFIX/etc/motd" ]; then
        mv "$PREFIX/etc/motd" "$PREFIX/etc/motd1"
        rm -rf zshrc
    fi
    rm -rf zshrc
    wget "${LINKS[zshrc]}" -O "$PREFIX/etc/zshrc" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "zshrc"
fi

# Download add.sh
check_exist "$HOME/.termux/add.sh" "add.sh "
if [ ! -e "$HOME/.termux/add.sh" ]; then
    wget "${LINKS[add_sh]}" -O "$HOME/.termux/add.sh" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "add.sh"
fi

# Clone oh-my-zsh if it doesn't exist
check_exist "$HOME/.oh-my-zsh" "oh-my-zsh "
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone --depth 1 "${LINKS[oh_my_zsh]}" "$HOME/.oh-my-zsh" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "oh-my-zsh"
fi

# Install powerlevel10k if it doesn't exist
check_exist "$HOME/powerlevel10k" "powerlevel10k "
if [ ! -d "$HOME/powerlevel10k" ]; then
    git clone --depth 1 "${LINKS[powerlevel10k]}" "$HOME/powerlevel10k" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "powerlevel10k"
fi

# Ensure plugins are installed
cd "$HOME/.oh-my-zsh/plugins" || exit 1
for plugin in git-flow-completion zsh-completions zsh-history-substring-search; do
    check_exist "$plugin" "$plugin "
    if [ ! -d "$plugin" ]; then
        case "$plugin" in
            "git-flow-completion")
                git clone "${LINKS[git_flow_completion]}" "$plugin" > /dev/null 2>> "$ERROR_LOG" &
                spin $! "$plugin"
                ;;
            "zsh-completions")
                git clone "${LINKS[zsh_completions]}" "$plugin" > /dev/null 2>> "$ERROR_LOG" &
                spin $! "$plugin"
                ;;
            "zsh-history-substring-search")
                git clone "${LINKS[zsh_history_substring_search]}" "$plugin" > /dev/null 2>> "$ERROR_LOG" &
                spin $! "$plugin"
                ;;
        esac
    fi
done

# Install syntax-highlighting and autosuggestions
mkdir -p "$PREFIX/etc/.plugin"
check_exist "$PREFIX/etc/.plugin/zsh-syntax-highlighting" "syntax-highlighting "
if [ ! -d "$PREFIX/etc/.plugin/zsh-syntax-highlighting" ]; then
    git clone "${LINKS[zsh_syntax_highlighting]}" "$PREFIX/etc/.plugin/zsh-syntax-highlighting" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "syntax-highlighting"
fi

check_exist "$PREFIX/etc/.plugin/zsh-autosuggestions" "autosuggestions "
if [ ! -d "$PREFIX/etc/.plugin/zsh-autosuggestions" ]; then
    git clone "${LINKS[zsh_autosuggestions]}" "$PREFIX/etc/.plugin/zsh-autosuggestions" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "zsh-autosuggestions"
fi

# Download .zshrc and .p10k.zsh
check_exist "$HOME/.zshrc" ".zshrc "
if [ ! -e "$HOME/.zshrc" ]; then
    wget "${LINKS[.zshrc]}" -O "$HOME/.zshrc" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "zshrc"
fi

check_exist "$HOME/.p10k.zsh" ".p10k.zsh "
if [ ! -e "$HOME/.p10k.zsh" ]; then
    wget "${LINKS[p10k_zsh]}" -O "$HOME/.p10k.zsh" > /dev/null 2>> "$ERROR_LOG" &
    spin $! "p10k.zsh"
fi

# Install additional packages for AstroNvim
apt install neovim lua-language-server luarocks stylua ripgrep lazygit yarn python python-pip ccls clang rust-analyzer -y > /dev/null 2>> "$ERROR_LOG" &
spin $! "packages for AstroNvim"

# Check if ~/.config director
#cd ~/.confi
if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
    echo "Created ~/.config directory"
fi

#cd ~/.config
# Check if nvim exists, and move it to nvim.bak if it does
if [ -d "$HOME/.config/nvim" ]; then
    cd ~/.config
    mv nvim nvim.bak.$(date +%Y.%m.%d-%H:%M:%S)
    #spin $! "backup existing nvim"
fi

# Download and unzip the new nvim setup
(cd ~/.config && wget "${LINKS[nvimasro]}" -O nvimasro.zip && unzip nvimasro.zip) > /dev/null 2>> "$ERROR_LOG" &
spin $! "nvim setup"

#cd ~/.config && unzip nvimasro.zip > /dev/null 2>> "$ERROR_LOG"
# if [ -d "$HOME/.config/nvimasro"]; then
#     cd ~/.config
#     mv nvimasro nvim > /dev/null 2>> "$ERROR_LOG"
# fi

# Create shortcut commands
echo "#!/data/data/com.termux/files/usr/bin/sh" > "$PREFIX/bin/addecho"
echo "bash ~/.termux/add.sh" >> "$PREFIX/bin/addecho"
chmod 777 "$PREFIX/bin/addecho"

echo "#!/data/data/com.termux/files/usr/bin/sh" > "$PREFIX/bin/tpecho"
echo "start-terminal" >> "$PREFIX/bin/tpecho"
chmod 777 "$PREFIX/bin/tpecho"

# Set zsh as the default shell
chsh -s zsh
cd ~
# Clean up temporary files
rm -rf ~/temp_art.txt
rm -rf ~/.config/nvimasro.zip



termux-reload-settings


echo -e "\n\e[32mSetup complete. Please restart your terminal or run 'zsh' to apply changes.\e[0m"

exit
