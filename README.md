```
╔════════════════════════════════════════════════╗
║            a c i d c o m p u t i n g           ║
╚════════════════════════════════════════════════╝
```

# dotfiles
This is my dotfiles repo. Built over the course of my GNU/Linux and *nix journey, these are the configs that I've hacked together and use in my systems. Still in development.

## zsh
`.zshrc` and `.aliases.zsh` contain the z shell configuration and shell aliases, respectively.
My Z shell config aims to be relatively simple, contains a couple of quality-of-life features and is tested and running on Arch Linux and Debian GNU/Linux. 
The zsh prompt uses a modified variant of the `fox` P10K zsh theme. 

Features:
- git plugin: colored prompt with branch and dirty/clean indicators.
- syntax highlighting: paths, commands and aliases
- autosuggestions: taken from `.zsh_history`, similar to Kali Linux's zshrc.
- tab completion: colored, menu-driven
- aliases: Kali ls aliases, custom ones.

## pacman
Not much to this config:
- `ILoveCandy`: enables pacman pellet effect when syncing.
- Parallel Downloads.
- Multilib enabled (Steam and other 32-bit programs.)

## htop
Htop config gets overwritten by any change. It only exists for testing.
two column layout
left: CPU cores with speed and usage, RAM, swap.
right: hostname, uptime, tasks, load average, disk IO, network IO, battery

## kitty
- Shell: z shell
- Modifier: ctrl+shift
- Theme: symfonic
- Font: JetBrains Mono Slashed (my favorite nerd font!)
- Transparency: 0.80
- Layout: tall

## fastfetch
Custom config with AFX ASCII logo.

## packages
The directory `pkgs/` contains lists of package names for the machines and distros I use. 
Some of these may be useful to new users; dig around and see which packages and programs I use.

## ASCII
ASCII art I find on the net.

## wallpapers
The wallpapers I use on my machines. Mosly Boards of Canada or IDM related. 

