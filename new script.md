# Termux Setup Script

This script automates the setup of a customized Termux environment on Android, including the installation of essential packages, themes, and configurations for a better terminal experience.

## Features

- Updates and upgrades existing packages.
- Installs essential tools such as Git, Zsh, and more.
- Sets up a custom theme and font for Termux.
- Configures Zsh with Oh-My-Zsh and Powerlevel10k for a modern shell experience.
- Downloads and installs useful plugins for Zsh.
- Creates shortcut commands for easy access to custom scripts.
- Configures terminal colors and settings.

## Requirements

- [Termux](https://f-droid.org/packages/com.termux/) installed on your Android device.

## Usage Instructions

1. **Clone the Repository** (if needed):
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
   cd YOUR_REPOSITORY_NAME
   ```

2. <details> <summary><b>View Setup Script ”EASY” </b></summary>

   -  <b>Create .sh folder</b>
       ```bash
       nano theme.sh
       ```
   - <details><summary><b>Script </b></summary>
   
        ```bash
            #!/bin/bash
            ERROR_LOG="$HOME/skip_errors.log"
            
            # Function to handle errors and log them
            log_error() {
                local task="$1"
                local error_msg="$2"
                echo -e "[ERROR] Task: $task | Error: $error_msg" >> "$ERROR_LOG"
            }
            
            # Spinner function for long-running tasks
            spin22 () {
                HIDECURSOR() { echo -en "\033[?25l"; }
                NORM() { echo -en "\033[?12l\033[?25h"; }
                local pid=$!
                local delay=0.25
                local spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
                local task="$1"
                local success_msg="$2"
                local fail_msg="$3"
            
                while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
                    for i in "${spinner[@]}"; do
                        HIDECURSOR
                        echo -ne "\033[34m\r[*] ${task} \e[34m[\e[33m${i}\e[34m]\033[0m"
                        sleep $delay
                        printf "\b\b\b\b\b\b\b\b"
                    done
                done
            
                wait $pid
                if [ $? -eq 0 ]; then
                    NORM
                    echo -e "\e[32m [ ${success_msg} ]\e[0m"
                else
                    NORM
                    echo -e "\e[31m [ ${fail_msg} ]\e[0m"
                    return 1
                fi
            }
            
            # Function to check existence of a file or directory
            spin22_exist () {
                local item="$1"
                local task="$2"
            
                HIDECURSOR() { echo -en "\033[?25l"; }
                NORM() { echo -en "\033[?12l\033[?25h"; }
            
                if [ -e "$item" ]; then
                    NORM
                    echo -e "\033[34m\r[*] ${task} \e[34m[\e[33mExists\e[34m]\033[0m"
                    return 0
                fi
                return 1
            }
            
            # Update and install necessary packages
            #pkg update --yes --force-yes && pkg upgrade --yes --force-yes
            #spin22 "Updating and upgrading packages" "Success" "Failed"
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
            
            # With this line:
            (apt-get update --yes && apt-get upgrade --yes) > /dev/null 2>> "$ERROR_LOG" &
            spin22 "Updating and upgrading apt packages" "Success" "Failed"
            
            # Install necessary packages
            pkg install git -y > /dev/null 2>> "$ERROR_LOG" &
            spin22 "Installing git" "Success" "Failed"
            
            # Clone the x-theme repository if it doesn't already exist
            spin22_exist "$HOME/x-theme" "x-theme directory"
            if [ ! -d "$HOME/x-theme" ]; then
                git clone https://github.com/tharindu899/x-theme "$HOME/x-theme" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Cloning font" "Success" "Failed"
            fi
            # Move font if it exists
            if [ -f "$HOME/x-theme/font.ttf" ]; then
                mv "$HOME/x-theme/font.ttf" "$HOME/.termux"
                rm -rf "$HOME/x-theme"
                termux-reload-settings
            fi
            
            # Install nala
            (apt-get install nala -y) > /dev/null 2>> "$ERROR_LOG" &
            spin22 "Installing nala" "Success" "Failed"
            
            # Install other necessary packages
            pkg install zsh bc python wget gh python-pip git micro openssh zip curl figlet logo-ls lsd -y > /dev/null 2>> "$ERROR_LOG" &
            spin22 "Installing additional packages" "Success" "Failed"
            
            # Setup color directory
            spin22_exist "$HOME/.termux/colour" "color directory exists" "Color directory already exists" "Color directory does not exist, creating"
            if [ ! -d "$HOME/.termux/colour" ]; then
                mkdir "$HOME/.termux/colour"
                if [ -e "$HOME/.termux/colors.properties" ]; then
                    mv "$HOME/.termux/colors.properties" "$HOME/.termux/colour/.colors.properties.bak.$(date +%Y.%m.%d-%H:%M:%S)"
                fi
                echo "#!colors colors.properties" > "$HOME/.termux/colors.properties"
                echo "background=#120321" >> "$HOME/.termux/colors.properties"
                #spin22 "Creating colors.properties" "Success" "Failed"
            fi
            
            
            # Download termux.properties
            if [ -e "$HOME/.termux/termux.properties" ]; then
                rm "$HOME/.termux/termux.properties"
              #  spin22 "Removed existing termux.properties" "Success" "Failed"
            fi
            wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/termux.properties -O "$HOME/.termux/termux.properties" > /dev/null 2>> "$ERROR_LOG" &
            spin22 "termux.properties" "Success" "Failed"
            termux-reload-settings
            
            # Download rxfetch if it doesn't exist
            #spin22_exist "$PREFIX/etc/rxfetch" "rxfetch exists"
            if [ ! -d "$PREFIX/etc/rxfetch" ]; then
                wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/rxfetch -O "$PREFIX/etc/rxfetch" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Downloading rxfetch" "Success" "Failed"
            fi
            
            # Download motd and zshrc
            spin22_exist "$PREFIX/etc/motd1" "motd1 exists" "motd1 already exists" "Downloading zshrc and renaming motd"
            if [ ! -e "$PREFIX/etc/motd1" ]; then
                # Check if motd exists before moving
                if [ -e "$PREFIX/etc/motd" ]; then
                    mv "$PREFIX/etc/motd" "$PREFIX/etc/motd1"
                    rm -rf zshrc
                else
                    echo "No motd file to rename."
                fi
                rm -rf zshrc
                wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/zshrc -O "$PREFIX/etc/zshrc" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Downloading zshrc" "Success" "Failed"
            fi
            
            # Download add.sh
            spin22_exist "$HOME/.termux/add.sh" "add.sh exists"
            if [ ! -e "$HOME/.termux/add.sh" ]; then
                wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/add.sh -O "$HOME/.termux/add.sh" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Downloading add.sh" "Success" "Failed"
            fi
            
            # Clone oh-my-zsh if it doesn't exist
            spin22_exist "$HOME/.oh-my-zsh" "oh-my-zsh exists"
            if [ ! -d "$HOME/.oh-my-zsh" ]; then
                git clone https://github.com/ohmyzsh/ohmyzsh "$HOME/.oh-my-zsh" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Cloning oh-my-zsh" "Success" "Failed"
            fi
            
            # Install powerlevel10k if it doesn't exist
            spin22_exist "$HOME/powerlevel10k" "powerlevel10k exists"
            if [ ! -d "$HOME/powerlevel10k" ]; then
                git clone --depth 1 https://github.com/romkatv/powerlevel10k "$HOME/powerlevel10k" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Cloning powerlevel10k" "Success" "Failed"
            fi
            
            # Ensure plugins are installed
            cd "$HOME/.oh-my-zsh/plugins" || exit 1
            for plugin in git-flow-completion zsh-completions zsh-history-substring-search; do
                spin22_exist "$plugin" "$plugin exists"
                if [ ! -d "$plugin" ]; then
                    case "$plugin" in
                        "git-flow-completion")
                            git clone https://github.com/bobthecow/git-flow-completion "$plugin" > /dev/null 2>> "$ERROR_LOG" &
                            ;;
                        "zsh-completions")
                            git clone https://github.com/zsh-users/zsh-completions "$plugin" > /dev/null 2>> "$ERROR_LOG" &
                            ;;
                        "zsh-history-substring-search")
                            git clone https://github.com/zsh-users/zsh-history-substring-search "$plugin" > /dev/null 2>> "$ERROR_LOG" &
                            ;;
                    esac
                    spin22 "Cloning $plugin" "Success" "Failed"
                fi
            done
            
            # Install syntax-highlighting and autosuggestions
            mkdir -p "$PREFIX/etc/.plugin"
            spin22_exist "$PREFIX/etc/.plugin/zsh-syntax-highlighting" "syntax-highlighting exists"
            if [ ! -d "$PREFIX/etc/.plugin/zsh-syntax-highlighting" ]; then
                git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PREFIX/etc/.plugin/zsh-syntax-highlighting" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Cloning syntax-highlighting" "Success" "Failed"
            fi
            
            spin22_exist "$PREFIX/etc/.plugin/zsh-autosuggestions" "autosuggestions exists"
            if [ ! -d "$PREFIX/etc/.plugin/zsh-autosuggestions" ]; then
                git clone https://github.com/zsh-users/zsh-autosuggestions "$PREFIX/etc/.plugin/zsh-autosuggestions" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Cloning zsh-autosuggestions" "Success" "Failed"
            fi
            
            # Download .zshrc and .p10k.zsh
            spin22_exist "$HOME/.zshrc" ".zshrc exists"
            if [ ! -e "$HOME/.zshrc" ]; then
                wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/.zshrc -O "$HOME/.zshrc" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Downloading .zshrc" "Success" "Failed"
            fi
            
            spin22_exist "$HOME/.p10k.zsh" ".p10k.zsh exists"
            if [ ! -e "$HOME/.p10k.zsh" ]; then
                wget https://raw.githubusercontent.com/tharindu899/addon/main/termux/zsh/.p10k.zsh -O "$HOME/.p10k.zsh" > /dev/null 2>> "$ERROR_LOG" &
                spin22 "Downloading .p10k.zsh" "Success" "Failed"
            fi
            
            # Create shortcut commands
            echo "#!/data/data/com.termux/files/usr/bin/sh" > "$PREFIX/bin/addecho"
            echo "bash ~/.termux/add.sh" >> "$PREFIX/bin/addecho"
            chmod 777 "$PREFIX/bin/addecho"
            
            echo "#!/data/data/com.termux/files/usr/bin/sh" > "$PREFIX/bin/tpecho"
            echo "start-terminal" >> "$PREFIX/bin/tpecho"
            chmod 777 "$PREFIX/bin/tpecho"
            
            # Set zsh as the default shell
            chsh -s zsh
            # Clean up temporary file
            rm -rf ~/temp_art.txt
            exit
        ```

   -  <b>install commands </b>
       ```bash
       bash theme.sh