# Configuration for a fresh Arch Linux install
This repository contains my personal dot files for various applications and tools. Below is a list of the configurations included:

- **Alacritty**: Configuration files for the Alacritty terminal emulator.
- **Btop**: Configuration files for the Btop resource monitor.
- **Cava**: Configuration for the Cava audio visualizer.
- **Hypr**: Configuration files for the Hyprland window manager and hyprpaper (wallpaper manager).
- **Fastfetch**: Custom settings for Neofetch.
- **Nvim**: Configuration for Neovim.
- **Oh My Bash**: Custom configurations for `.bashrc`.
- **Ranger**: Configuration files for the Ranger file manager.
- **Spotify/Spicetify**: Custom themes and settings for Spotify using Spicetify.
- **Waybar**: Configuration for the Waybar status bar.
- **Wofi**: Configuration files for the Wofi application launcher.

## Contents

- [How to Install](#how-to-install)
- [Customization](#customization)
    - [Fonts](#fonts)
    - [Bash Configuration](#bash-configuration)
    - [Keybindings](#keybindings)
    - [Backup Your Configurations](#backup-your-configurations)  
- [To-Do List](#to-do)


## How to Install

To install these dot files, follow these steps. It is recommended to perform the installation after a fresh Arch Linux installation to ensure compatibility and avoid conflicts with existing configurations:

1. Clone the repository:
    ```sh
    git clone https://github.com/Gaxalco/archconfig
    ```

2. Navigate to the cloned repository:
    ```sh
    cd archconfig
    ```

3. Run the install script:
    ```
    ./install.sh
    ```  

> <span style="color:red">**WARNING**</span> : Running Hyprland in another tty than your gretter will make alacritty unusable !

## Customization

### Fonts

To change the fonts in Alacritty, edit the `alacritty.yml` file. The default font is set to "Monaspace Neon". You can replace it with any font of your choice. The "Monaspace Neon" font is included in this repository and will be installed to `~/.local/share/fonts` during the installation process.

### Bash Configuration

To change the theme in your `.bashrc`, locate the line that starts with `OSH_THEME=""` and replace the empty quotes with the name of the desired theme. For example:

```sh
OSH_THEME="kitsune"
```

You can find a list of available themes in the [Oh My Bash Themes](https://github.com/ohmybash/oh-my-bash/blob/master/themes/THEMES.md) repository.

### Keybindings

You can customize the keybindings for Hyprland by editing the `~/.config/hypr/hyprland.conf` file. Below is an example of how to set up some common keybindings:

```ini
# Example keybindings
bind = SUPER+Return, exec, alacritty
bind = SUPER+d, exec, wofi --show drun
bind = SUPER+Shift+q, killactive
bind = SUPER+f, fullscreen
bind = SUPER+Left, workspace, prev
bind = SUPER+Right, workspace, next
```

Feel free to modify these keybindings to suit your preferences. For a complete list of available commands and options, refer to the [Hyprland documentation](https://github.com/hyprwm/Hyprland/wiki/Keybinds).

### Backup Your Configurations

You can backup your own configuration files in this repository using the provided `backup.sh` script. To do so, follow these steps:

1. Run the backup script:
    ```sh
    ./backup.sh
    ```

    This script will copy all your configuration files into the repository.

2. Create a new branch for your backup:
    ```sh
    git checkout -b my-backup-branch
    ```

3. Commit your changes:
    ```sh
    git add .
    git commit -m "Backup my configuration files"
    ```

4. Push your changes to the repository:
    ```sh
    git push origin my-backup-branch
    ```

This way, you can keep your configurations safe and easily accessible.

## To-Do

- Ranger config (currently no files in .config/ranger)
- Add Dolphin
- Add SDDM config (for users with SDDM installed as their greeter)
