#!/bin/bash

# Timer function to display messages with a delay
message_with_timer() {
    clear
    local message="$1"
    local dots=""
    for i in {1..4}; do
        echo -ne "\r$message$dots"
        sleep 1
        dots="$dots."
    done
}

# Update system and install base packages
message_with_timer "Updating system and installing base packages"
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed brightnessctl curl git

# Install yay (AUR helper) if not already installed
if ! command -v yay &> /dev/null; then
    message_with_timer "yay is not installed. Installing yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# List of packages to install

alacritty_package=(alacritty)

cava_package=(cava)

btop_package=(btop)

hyprpaper_package=(hyprpaper)

fastfetch_package=(fastfetch)

neovim=(neovim python-lsp-all vim-language-server python-pynvim nodejs npm ctags ripgrep python-pylint flake8 vint) 

oh_my_bash_package=false

ranger_package=(ranger)

spotify_launcher_package=false

waybar_package=(waybar pacman-contrib pipewire-pulse alsa-utils pavucontrol playerctl ttf-font-awesome ttf-jetbrains-mono-nerd)

wofi_package=(wofi)

additional_packages=(wget tar unzip zip)

# Interface to select packages to install

# Initialize options
options=("All" "Alacritty" "Cava" "Btop" "Hyprpaper" "Fastfetch" "Neovim" "Oh My Bash" "Ranger" "Spotify Launcher" "Waybar" "Wofi" "Additional Packages" "Done")
selected=(0 0 0 0 0 0 0 0 0 0 0 0 0 0)
cursor=0

# Function to print the menu
print_menu() {
    clear
    echo "Use space to select."
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$cursor" ]; then
            cursor_char=">"
        else
            cursor_char=" "
        fi

        if [ "$i" -eq $((${#options[@]}-1)) ]; then
            echo "$cursor_char ${options[$i]}"
        else
            if [ "${selected[$i]:-0}" -eq 1 ]; then
                echo "$cursor_char [*] ${options[$i]}"
            else
                echo "$cursor_char [ ] ${options[$i]}"
            fi
        fi
    done
}

# Function to toggle selection
toggle_selection() {
    if [ $cursor -eq 0 ]; then
        if [ ${selected[0]} -eq 1 ]; then
            for i in "${!selected[@]}"; do
                selected[$i]=0
            done
        else
            for i in "${!selected[@]}"; do
                selected[$i]=1
            done
            selected[${#options[@]}-1]=0
        fi
    else
        selected[$cursor]=$((1 - ${selected[$cursor]}))
        if [ ${selected[0]} -eq 1 ]; then
            selected[0]=0
        fi
    fi
}

# Main loop
while true; do
    print_menu

    read -rsn1 input
    case $input in
        $'\x1b') # Handle escape sequences
            read -rsn2 -t 0.1 input
            if [[ $input == "[A" ]]; then
                ((cursor--))
                if [ $cursor -lt 0 ]; then
                    cursor=$((${#options[@]}-1))
                fi
            elif [[ $input == "[B" ]]; then
                ((cursor++))
                if [ $cursor -ge ${#options[@]} ]; then
                    cursor=0
                fi
            fi
            ;;
        "") # Enter key
            toggle_selection
            ;;
    esac

    if [ ${selected[${#options[@]}-1]} -eq 1 ]; then
        break
    fi
done

# Make a list of selected packages
selected_packages=()
for i in "${!selected[@]}"; do
    if [ ${selected[$i]} -eq 1 ]; then
        case $i in
            1)
                selected_packages+=("${alacritty_package[@]}")
                ;;
            2)
                selected_packages+=("${cava_package[@]}")
                ;;
            3)
                selected_packages+=("${btop_package[@]}")
                ;;
            4)
                selected_packages+=("${hyprpaper_package[@]}")
                ;;
            5)
                selected_packages+=("${fastfetch_package[@]}")
                ;;
            6)
                selected_packages+=("${neovim[@]}")
                ;;
            7)
                oh_my_bash_package=true
                ;;
            8)
                selected_packages+=("${ranger_package[@]}")
                ;;
            9)
                spotify_launcher_package=true
                ;;
            10)
                selected_packages+=("${waybar_package[@]}")
                ;;
            11)
                selected_packages+=("${wofi_package[@]}")
                ;;
            12)
                selected_packages+=("${additional_packages[@]}")
                ;;
        esac
    fi
done


# Function to install additional packages
install_additional_packages() {
    read -p "Enter a space-separated list of additional packages to install: " -a packages

    for package in "${packages[@]}"; do
        if [ -z "${packages[*]}" ]; then
            echo "No additional packages to install. Exiting..."
            break
        elif [[ " ${selected_packages[@]} " =~ " ${package} " ]]; then
            echo "Package $package is already being installed later in the script. Skipping..."
        elif yay -Si "$package" &> /dev/null; then
            echo "Installing $package..."
            yay -S --noconfirm "$package"
        else
            echo "Package $package does not exist in the repositories."
        fi
    done
}

# Call the function to install additional packages
install_additional_packages

# Install packages from official repositories
message_with_timer "Installing selected packages"

yay -S --needed --noconfirm "${selected_packages[@]}"
sleep 2


# Debug for checkupdates
sudo rm /etc/resolv.conf
sudo systemctl enable systemd-resolved.service
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl restart systemd-resolved.service

# Install fonts (Monaspace)
message_with_timer "Installing Monaspace font"
git clone https://github.com/githubnext/monaspace.git
mv monaspace ~/.local/share/fonts

# Install oh-my-bash
if [ "$oh_my_bash_package" == true ]; then
    if [ ! -d "$HOME/.oh-my-bash" ]; then
        message_with_timer "oh-my-bash is not installed. Installing oh-my-bash"
        mkdir src/oh-my-bash
        cd src/oh-my-bash
        curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh | sh
        cd ../..
    else
        message_with_timer "oh-my-bash is already installed. Skipping"
    fi
fi

# Install spicetify
if [ "$spotify_launcher_package" == true ]; then
    message_with_timer "Installing spicetify"
    curl -fsSL https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.sh | sh
    spicetify backup apply enable-devtool
    spicetify config extensions dribbblish.js
    spicetify config current_theme dribbblish
    spicetify apply
fi

# Move configuration files of selected packages to the correct location
message_with_timer "Moving configuration files"
cp -r src/.config/* ~/.config

clear
echo "All packages have been installed successfully."
echo "Please restart your system to apply changes."