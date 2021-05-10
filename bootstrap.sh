#!/bin/bash

# Bootstrap home dotfiles for new user and Kali install

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

#

check="\u2713"
info="i"
missing="\u2715"

sudo_check() {
    echo -e "[$info] Checking for sudo"
    apt search sudo | grep installed 2>/dev/null
    if [ $? != 0 ]; then
        echo -e "\n[$missing] Sudo not installed. Install sudo and assign privilege to $username"
        exit
    fi
    cd ~
}

directory_check() {
    echo -e "[$info] Creating config folders structure..."
    mkdir -p {.config/zsh,.config/qterminal.org}
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    
}

vm_check() {
    echo -e "[$info] Checking if this is a running virtual machine..."
    sudo dmesg | grep vmware >/dev/null
    if [ $? == 0 ]; then
        echo -e "[$info] Installing VM tools..."
        sudo apt install -y open-vm-tools
        if [ $? == 0 ]; then
            echo -e [$check]
        else
            echo -e [$missing]
        fi
    else 
        echo -e "[$info] Not a VM..."
    fi
    cd ~
}

unzip_check(){
    echo -e "[i] Installing UnZIP..."
    sudo apt install -y unzip
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    cd ~
}

zsh_check() {
    echo -e "[i] Installing ZSH shell..."
    sudo apt install -y zsh
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    
    echo -e "[i] Enabling ZSH for $username..."
    sudo usermod --shell $(which zsh) $username
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    cd ~
}

powerlevel10k_check() {
    echo -e "[$info] Installing PowerLevel10K..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/powerlevel10k
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    echo -e "[$info] Installing ZSH Plugins..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting
    cd .config/zsh
    mkdir zsh-sudo
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.sh
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
}

qterminal_check() {
    echo -e "[$info] Installing Qterminal..."
    sudo apt install -y qterminal
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    cd ~
}

vim_check() {
    echo -e "[$info] Installing Vim + Airline + Themes..."
    sudo apt install -y vim vim-airline vim-airline-themes
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    cd ~
}

bravebrowser_check() {
    read -p "Do you need Brave Browser installed? [y/N] " bbi
    bbi="n"
    if [ $bbi = "Y" -o $bbi = "y" ]; then
        echo -e "[$info] Installing Brave Browser..."
        sudo apt install -y apt-transport-https curl
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update && sudo apt install -y brave-browser
        if [ $? == 0 ]; then
            echo -e [$check]
        else
            echo -e [$missing]
        fi
    fi
    cd ~
}

lsd_check() {
    echo -e "[$info] Installing LSD (enhanced ls)..."
    cd $(mktemp -d)
    v=$(curl -s https://github.com/Peltoche/lsd/releases/latest | sed -E 's/.*"([^"]+)".*/\1/' | awk -F'/tag/' '{print $2}')
    wget $(curl -s https://github.com/Peltoche/lsd/releases/latest/ | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/tag/download/g')/lsd_$(curl -s https://github.com/Peltoche/lsd/releases/latest | sed -E 's/.*"([^"]+)".*/\1/' | awk -F'/tag/' '{print $2}')_amd64.deb
    sudo dpkg -i *.deb
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    cd ~
}

fzf_check() {
    echo -e "[$info] Installing Fuzzy Finder..."
    cd /opt
    sudo git clone --depth=1 https://github.com/junegunn/fzf.git
    cd fzf
    sudo ./install
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
    cd ~
}

fonts_check() {
    echo -e "[$info] Installing Hack Nerd fonts..."
    cd $(mktemp -d)
    wget $(curl -s https://github.com/ryanoasis/nerd-fonts/releases/latest/ | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/tag/download/g')/Hack.zip
    sudo unzip Hack.zip -d /usr/local/share/fonts
    cd /usr/local/share/fonts
    fc-cache -f -v
    sudo fc-cache -f -v
    cd ~
}

dotfiles_download() {
    echo -e "[$info] Downloading relevant dotfiles..."
    wget -O .zshrc https://raw.githubusercontent.com/aci686/dotfiles/main/.zshrc
    wget -O .vimrc https://raw.githubusercontent.com/aci686/dotfiles/main/.vimrc
    wget -O .p10k.zsh https://raw.githubusercontent.com/aci686/dotfiles/main/.p10k.zsh
    wget -O .fzf.zsh https://raw.githubusercontent.com/aci686/dotfiles/main/.fzf.zsh
    sed -i 's/[username]/$(whoami)/g' .fzf.zsh
    wget -O ~/.config/qterminal.org/qterminal.ini https://raw.githubusercontent.com/aci686/dotfiles/main/.config/qterminal.org/qterminal.ini
    cd ~
}

username=$(whoami)

sudo_check
#directory_check
vm_check
unzip_check
zsh_check
powerlevel10k_check
qterminal_check
vim_check
bravebrowser_check
lsd_check
fzf_check
fonts_check
dotfiles_download
