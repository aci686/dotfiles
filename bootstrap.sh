#!/bin/bash

#

__author__="Aaron Castro"
__author_email__="aaron.castro.sanchez@outlook.com"
__copyright__="Aaron Castro"
__license__="MIT"

#

check="\u2713"
info="i"
missing="\u2715"

echo -e "[$info] Checking for sudo"
apt search sudo | grep installed 2> /dev/null
if [ $? != 0 ]; then
    echo -e "\n[$missing] Sudo not installed. Install sudo and assign privilege to $(whomai)"
    exit
fi

echo -e "[$info] Adding additional apt repos..."
#sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$info] Checking if this is a running virtual machine..."
sudo dmesg | grep vmware >/dev/null
if [ $? == 0 ]; then
    echo -e "[$info] Installing VM tools..."
    sudo apt install -y open-vm-tools >/dev/null
    if [ $? == 0 ]; then
        echo -e [$check]
    else
        echo -e [$missing]
    fi
else 
    echo -e "[$info] Not a VM..."
fi

echo -e "[i] Installing required packages..."
sudo apt install -y lightdm bspwm sxhkd compton feh terminator zsh >/dev/null
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

echo -e "[$info] Creating config folders structure..."
mkdir -p {.config/bspwm,.config/compton,.config/polybar,.config/rofi,.config/sxhkd,.zsh,.bin}
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$info] Installing PowerLevel10K..."
git clone --depth=1 https://github.com/romaktv/powerlevel10k.git ~/.config/powerlevel10k
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

read -p "Which HTTP repo has fonts available? " http_repo
echo -e "[$info] Installing Hack Nerd Font..."
cd $(mktemp -d)
wget http://$(http_repo)/Hack-Nerd-Font.tgz
sudo tar -zxvf Hack-Nerd-Font.tgz --directory /usr/local/share/fonts
cd /usr/local/share/fonts/Hack-Nerd-Font
sudo mv *ttf ../
cd ../
sudo rm -rf Hack-Nerd-Font
fc-cache -f -v
sudo fc-cache -f -v
cd ~

echo -e "[$info] Installing ZSH Plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-sysntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting
cd .config/zsh
mkdir zsh-sudo
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.sh
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$infp] Installing Rofi..."
sudo apt install -y rofi >/dev/null
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$info] Installing Polybar..."
echo -e "[$info] Installing required dependencies..."
apt install -y build-essential cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-radnr0-dev libxcb-composite0-dev python3-xcbgen xbd-proto libxcb-image0-dev libxcb-ewmh-dev libscb-icccm4-dev fonts-font-awesome libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev libscb-composite0-dev >/dev/null
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

cd /opt
sudo git clone --recursive https://github.com/polybar/polybar
sudo chmod +x build.sh
sudo ./build.sh --all-features
cd ~
git clone https://github.com/adi1090x/polybar-themes
cd polybar-themes/polybar-11
cp -t * ~/.config/polybar
cd ~
rm -rf polybar-themes

echo -e "[$info] Installing Vim + Airline + Themes..."
sudo apt install -y vim vim-airline vim-airline-themes >/dev/null
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$info] Installing LSD (enhanced ls)..."
cd $(mktemp -d)
wget http://$(http_repo)/lsd_0.18.0_amd64.deb
sudo dpkg -I lsd_0.18.0._amd64.deb
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi
rm lsd_0.18.0._amd64.deb

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

echo -e "[$info] Installing Nemo explorer..."
cd ~
sudo apt install nemo
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$info] Set terminator as default terminal for Nemo's context menus..."
gsettings set org.cinnamon.desktop.default-application.terminal exec terminator
gsettings set org.cinnamon.desktop.default-application.terminal exec-arg terminator
if [ $? == 0 ]; then
    echo -e [$check]
else
    echo -e [$missing]
fi

echo -e "[$info] Install destop and icon themes..."
wget http://somerepo/Bubble-Dark-Blue.tgz
wget http://somerepo/Sensual-Breeze-Dark.tgz
tar -zxvf Bubble-Dark-Blue.tgz /usr/share/themes/
tar -zxvf Sensual-Breeze-Dark.tgz /usr/share/icons/

echo -e "[$info] Install Firefox web browser..."
cd /opt
wget http://somerepo/Firefox-83.0.tgz
sudo tar -zxvf Firefox-83.0.tgz


cd ~
sudo apt install -y libdbus-glib-1-2
sudo ln -s /opt/firefox/firefox /usr/bin/firefox
sudo ln -s /home/i686/Pictures/Wallpapers/02.jpg /usr/share/images/desktop-base/02.jpg

sudo sed -e 's/Adwaita/Adwaita-dark/g' /usr/share/lightdm/lightdm-gtk-greete.conf.d/01_debian.conf
sudo sed -e 's/login-background.svg/02.jpg/g' /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_debian.conf

echo -e "[$info] Install screen lock with auto timer..."
sudo apt install i3lock-fancy
sudo apt install xautolock 
