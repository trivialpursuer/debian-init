#!/bin/bash
set -e

#Grab directory that this script exists in
INIT_DIR=$(dirname $(readlink -f ${BASH_SOURCE[0]}))

#Do I have root access?


################### Packages, libraries, and applications ######################

dontrun() {

#First thing first, install all standard packages I use.
sudo apt update
sudo apt-get install -y -f
sudo apt install -y \
	gcc pkg-config automake nasm		\
	git repo lib32stdc++6 bison flex 	\
	autoconf autopoint libtool cmake 	\
	libltdl-dev gawk libssl-dev python-dev 	\
	python-numpy python-pathlib lsof	\
	python-crypto python-pip mtd-utils	\
	dos2unix liblz4-tool openssl git-lfs	\
	p7zip filezilla zsh python-protobuf	\
	tmux tftpd-hpa valgrind wireshark	\
	protobuf-c-compiler nmap screen	tftp 	\
	default-jdk awscli fastboot snapd	\
	libgconf-2-4 libxss1 libappindicator1	\
	python3-dev python3-pip			\
	python3-setuptools exuberant-ctags
	
#Create a directory for storing packages.
DEBS_DIR=~/Downloads/debs
mkdir -p ${DEBS_DIR}

#Keybase 
curl -o ${DEBS_DIR}/keybase_amd64.deb --remote-name \
	https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i ${DEBS_DIR}/keybase_amd64.deb
sudo apt-get install -f

#Snap may have already installed the following applications. If so, we do not
#wish to abort the script.
set +e

#Slack
sudo snap install slack --classic

#Docker
sudo snap install docker

#Spotify
sudo snap install spotify

#Re-enable abort on error
set -e

########################## Important repositories ##############################

#Configure basic directories
mkdir -p ~/.local/bin ~/.local/man/man1

GIT_DIR=~/projects
mkdir -p ${GIT_DIR}

#Thefuck
if ! [ -d ${GIT_DIR}/thefuck ]; then
	git clone https://github.com/nvbn/thefuck ${GIT_DIR}/thefuck
fi
sudo pip3 install ${GIT_DIR}/thefuck

#Picocom
if ! [ -d ${GIT_DIR}/picocom ]; then
	git clone https://github.com/npat-efault/picocom ${GIT_DIR}/picocom
fi
make -C ${GIT_DIR}/picocom && cp ${GIT_DIR}/picocom/picocom ~/.local/bin && \
	cp ${GIT_DIR}/picocom/picocom.1 ~/.local/man/man1


}
####################### My Shell and homedir configuration #####################

#Configure my preferred shell (zsh)
OH_MY_ZSH_URL=\
https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
cd && RUNZSH=no sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"

#Copy my custom .zshrc
cp ${INIT_DIR}/.zshrc ~

#FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

################################# Vim Config ###################################

#Install Pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/colors && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

#My custom vim config file
cp ${INIT_DIR}/.vimrc ~

#Colorscheme file
cp ${INIT_DIR}/jellybeans.vim ~/.vim/colors

#Plugins may have already installed the following applications. If so, we do not
#wish to abort the script.
set +e

#Gundo
git clone https://github.com/sjl/gundo.vim ~/.vim/bundle/gundo

#NERDTree
git clone https://github.com/scrooloose/nerdtree ~/.vim/bundle/nerdtree

#Fugitive
git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle/vim-fugitive
vim -u NONE -c "helptags vim-fugitive/doc" -c q

#Tagbar
git clone https://github.com/majutsushi/tagbar.git ~/.vim/bundle/tagbar

set -e
