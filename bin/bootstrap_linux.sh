#!/bin/bash -ex

# Paste this into ssh
# curl -sL https://raw.github.com/evgenyshulman/dotfiles/master/bin/bootstrap_linux.sh | tar -xzO | /bin/bash -ex
# When forking, you can get the URL from the raw (<>) button.

### Set some command variables depending on whether we are root or not ###
# This assumes you use a debian derivate, replace with yum, pacman etc.
aptget='sudo apt-get'
chsh='sudo chsh'
if [ `whoami` = 'root' ]; then
	aptget='apt-get'
	chsh='chsh'
fi

### Install git and some other tools we'd like to use ###
$aptget update
$aptget install -y zsh tmux vim git

### Install homeshick ###
git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
source $HOME/.homesick/repos/homeshick/homeshick.sh

### Trust github ###
mkdir -p .ssh
cat <<EOF >> .ssh/known_hosts
|1|6WX8FDwncDK8tfyfkLLbvyepVRw=|15RHFpHg3GHML7eJqvNL/yVYChI= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|cccEMXs7ur0u/JXs4NQYv4A9Xb8=|Pddv+wa776NKeZ4v1yMn1cZWt4s= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EOF

### Set SSH_AUTH_SOCK etc. ###
eval `ssh-agent -s`

homeshick --batch clone https://github.com/evgenyshulman/dotfiles.git

### Clone public repos ###
homeshick --batch clone https://github.com/sorin-ionescu/prezto.git

### Ling prezto
ln -s $HOME/.homesick/repos/prezto $HOME/.zprezto/

### Link it all to $HOME ###
homeshick link

### Set default shell to your favorite shell ###
$chsh --shell /bin/zsh `whoami`
echo "Log in again to start your proper shell"