#! /bin/bash
echo "---"

set -e

info () {
  printf "\r  [\033[00;34m..\033[0m] %s \n" "$1"
}

user () {
  printf "\r  [\033[0;33m??\033[0m] %s \n" "$1"
}

success () {
  printf "\r\033[2K [\033[00;32mOK\033[0m] %s \n" "$1"
}

fail () {
  printf "\r\033[2K [\033[0;31mFAIL\033[0m] %s \n" "$1"
  echo ''
  exit
}

load_pre_script() {
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
  success "Built Locate Database"

  mkdir -p ~/sys_log/
  touch ~/sys_log/attacker.log

  cd ~/.dotfiles/scripts/ssh && \
    cp -i sshrc  ~/.ssh/

  success "Setup sshrc config"
}

install_homebrew() {
  read -r -p "Do you want to install homebrew? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    git clone https://github.com/Homebrew/brew homebrew
    brew update --force --quiet
    eval "$(homebrew/bin/brew shellenv)"

    chmod -R go-w "$(brew --prefix)/share/zsh"

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/cask
    
    success "Installed homebrew"
  fi
}

install_ninja() {
  read -r -p "Do you want to install ninja and lua lsp? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install ninja
    
    cd ~/.dotfiles/nvim
    git clone https://github.com/sumneko/lua-language-server
    cd lua-language-server
    git submodule update --init --recursive

    cd 3rd/luamake
    compile/install.sh
    cd ../..
    ./3rd/luamake/luamake rebuild

    brew install luarocks
    luarocks install --server=https://luarocks.org/dev luaformatter
    
    success "Installed nija and setup lua lsp"
  fi
}

install_languages() {
  read -r -p "Do you want to install languages? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install asdf
    success "Installed asdf"

    asdf plugin-add rust
    asdf install rust 1.55.0
    asdf global rust 1.55.0
    success "Installed rust"

    asdf plugin-add python
    asdf install python 3.7.3
    asdf global python 3.7.3
    success "Installed python"

    asdf plugin-add golang
    asdf install golang latest
    success "Installed golang"

    asdf plugin-add ruby
    asdf install ruby latest
    asdf global ruby 3.1.1
    success "Installed ruby"
  fi
  
}

install_devops() {
  read -r -p "Do you want to install devops tools? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install docker --cask
    brew install lazydocker
    success "Installed docker"

    brew install vagrant
    cp -i ~/.dotfiles/scripts/vagrant/VAGRANTFILE  ~/Dev/VM
    success "Installed vagrant"

    brew install minikube
    brew install helm
    brew install hyperkit
    brew install kubectx
    success "Installed k8s"

    brew install pstree
    success "Installed pstree"
  fi
}

setup_penetration_tools() {
  read -r -p "Do you want to install some penetration tools ? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install owasp-zap
    brew install nmap
    brew install openconnect
    brew install openvpn
    
    chmod +x ./tools/beef/install
    ./tools/beef/install
    
    success "Installed penetration tools"
  fi
}

setup_git() {
  read -r -p "Do you want to setup git? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install gh 
    success "Installed GitHub CLI"
    
    git config --global user.email "huynguyennbk@gmail.com"
    git config --global user.name  "Louis Nguyen"
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global color.ui true
    git config --global color.diff-highlight.oldNormal "red bold"
    git config --global color.diff-highlight.oldHighlight "red bold 52"
    git config --global color.diff-highlight.newNormal "green bold"
    git config --global color.diff.meta "11"
    git config --global color.diff.frag "magenta bold"
    git config --global color.diff.commit "yellow bold"
    git config --global color.diff.old "red bold"
    git config --global color.diff.new "green bold"
    git config --global color.diff.whitespace "red reverse"

    git config --global pull.rebase true
    git config --global rebase.autoStash true

    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status

    success "Setup Git Successfully"
  fi
}

install_fish() {
  read -r -p "Do you want to install fish? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install fish
    curl -sL https://git.io/fisher | source

    sudo chsh -s "$(which fish)"
    fisher update
    
    success "Installed fish"
  fi
}

install_font() {
  read -r -p "Do you want to install font? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts

    brew tap homebrew/cask-fonts
    brew install font-hack-nerd-font

    # Better font display on Mac
    defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO

    success "Installed font!"
  fi
}

install_terminal() {
  read -r -p "Do you want to install kitty? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install --cask kitty

    success "Installed kitty terminal"
  fi

  read -r -p "Do you want to install wezterm? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew tap wez/wezterm
    brew install --cask wez/wezterm/wezterm

    success "Installed wezterm terminal"
  fi
}

install_nvim() {
  read -r -p "Do you want to install neovim? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    info "Installing neovim"
    brew install lua
    brew install --HEAD neovim

    # reduce keyrepeat for faster typing in vim
    defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
    defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

    success "Installed neovim"
  fi
}

install_emacs() {
  read -r -p "Do you want to install emacs? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    info "Installing emacs"
    brew install --cask emacs
    brew tap d12frosted/emacs-plus
    brew install emacs-plus --with-no-titlebar

    success "Installed emacs"
  fi
}

install_tmux() {
  read -r -p "Do you want to install tmux? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install tmux
    rm ~/.tmux.conf
    cd ~/.dotfiles/terminals && stow tmux -t ~/

    rm -rf ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}

install_window_manager() {
  read -r -p "Do you want to install window manager? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install koekeishiya/formulae/yabai --HEAD
    codesign -fs 'yabai-cert' "$(which yabai)"

    sudo yabai --install-sa
    touch ~/sys_log/yabailogs.txt # create log file

    brew services start yabai
    killall Dock

    brew install somdoron/formulae/spacebar

    brew tap FelixKratz/formulae
    chmod +x ~/.dotfiles/scripts/*

    brew install koekeishiya/formulae/skhd
    brew services start skhd

    success "Installed window manager! Remember to disable System Integrity Protection (SIP)"
  fi
}

install_qutebrowser() {
  read -r -p "Do you want to install qutebrowser? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install qutebrowser --cask
  fi
}

install_nnn() {
  read -r -p "Do you want to install qutebrowser? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    cd /tmp
    git clone git@github.com:jarun/nnn.git
    cd nnn

    # Build with nerd icon
    make O_NERD=1 

    sudo cp nnn /usr/local/bin
    rm -rf  /tmp/nnn
  fi
}

install_tools() {
  read -r -p "Do you want to install some fancy tools ? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]];then
    brew install ripgrep
    brew install neofetch
    brew install languagetool
    brew install pgcli
    brew install mycli
    brew install bat
    brew install httpie
    brew install diff-so-fancy
    brew install terminal-notifier
    brew install bluetoothconnector
    brew install exa
    brew install fzf
    brew install pidof
    brew install watch
    brew install brightness
    brew install autojump
    brew install --cask burp-suite
    brew install mas
    brew install pass
    brew install asciinema
    brew install asdf
    brew install efm-langserver
    brew install --cask unnaturalscrollwheels
    brew install adr-tools
    brew install ack
    brew install bpytop
    brew install khanhas/tap/spicetify-cli
    brew install dos2unix
    brew install jq
    brew install shellcheck
    brew install fd
    brew install act # github action test locally

    pip install pydf
    pip install diagrams

    sudo port install zathura
    sudo port install zathura-docs
    sudo port install zathura-plugin-pdf-mupdf

    ln -s ~/.dotfiles/suckless/zathura ~/.config/
    "$(brew --prefix)"/opt/fzf/install

    brew install isacikgoz/taps/tldr

    brew install rustscan
    brew install osquery
    brew install glow

    brew install grpcurl

    brew install --cask graphiql

    brew tap yoheimuta/protolint
    brew install protolint

    brew install gum

    brew install entr

    brew install xclip

    success "Installed some fancy tools"
  fi
}

link_all_dotfiles() {
  brew install stow

  rm -rf ~/.config/alacritty
  rm ~/.tmux.conf
  rm -rf ~/.zshrc

  mkdir -p ~/.config/kitty
  mkdir -p ~/.config/fish
  mkdir -p ~/.config/wezterm

  cd ~/.dotfiles/terminals && \
    stow kitty -t ~/.config/kitty && \
    stow fish -t ~/.config/fish && \
    stow wezterm -t ~/.config/wezterm && \
    stow tmux -t ~/ && \
  success "Linked terminals"

  mkdir -p ~/.config/nvim
  cd ~/.dotfiles && stow nvim -t ~/.config/nvim
  success "Linked neovim"

  cd ~/.dotfiles && stow emacs -t ~/
  success "Linked emacs"

  rm -rf ~/.skhdrc
  rm -rf ~/.yabairc
  rm -rf ~/.spacebarrc
  cd ~/.dotfiles/suckless/mac_os && stow spacebar -t ~/ && stow yabai -t ~/ && stow skhdrc -t ~/

  success "Linked window manager"

  rm -rf ~/.qutebrowser
  ln -s ~/.dotfiles/suckless/qutebrowser ~/.qutebrowser

  success "Linked qutebrowser"

  mkdir -p ~/.config/bpytop
  cd ~/.dotfiles/suckless && stow nnn -t ~/.config && stow bpytop -t ~/.config/bpytop

  mkdir -p ~/.config/spicetify
  ln -s ~/.dotfiles/suckless/spicetify ~/.config/spicetify
  spicetify apply

  success "Linked other tools"

  ln -s ~/.dotfiles/suckless/git/.gitconfig ~/.gitconfig
  success "Linked git config"
}

load_pre_script

install_homebrew
setup_git
install_manage_tools
install_ninja
install_languages
install_devops
setup_penetration_tools
install_fish
install_font
install_terminal
install_nvim
install_emacs
install_tmux
install_window_manager
install_qutebrowser
install_nnn
link_all_dotfiles
install_tools

echo "---"

echo "Finish Install!"
