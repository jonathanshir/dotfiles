#!/bin/zsh

DOTFILES_HOME=$HOME/.homesick/repos/dotfiles

if [ -f ~/.exports ]; then
	source ~/.exports
fi

if [ -f ~/.localenv ]; then
	source ~/.localenv
fi

# homeshick stuff
source $HOME/.homesick/repos/homeshick/homeshick.sh
# Check if castles need refreshing
homeshick --quiet refresh 14 $HOMESHICK_REFRESH_REPOS
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)



system=`$DOTFILES_HOME/system`
omz_dir=$HOME/.homesick/repos/oh-my-zsh

if [[ -e $omz_dir/oh-my-zsh.sh ]] then
	export ZSH=$omz_dir
	# Let homeshick handle the updating
	DISABLE_AUTO_UPDATE="true"
	if [[ -z "$ZSH_THEME" ]] then
	    ZSH_THEME="robbyrussell"
        #ZSH_THEME="jreese"
	fi
	plugins+=(extract git history-substring-search pip colored-man tmuxinator tmux )
	if [[ $system == 'Linux' ]]; then
		plugins+=()
	fi
	if [[ $system == 'OSX' ]]; then
		plugins+=(brew terminalapp osx)
	fi
	source $omz_dir/oh-my-zsh.sh

	unsetopt correct_all
	unsetopt sharehistory

	# Disable the automatic titling, it screws up tmux
	DISABLE_AUTO_TITLE=true

    bindkey "^[[1;7C" forward-word
    bindkey "^[[1;7D" backward-word


fi
unset omz_dir

if [[ $system == 'Linux' ]]; then
	source $DOTFILES_HOME/zsh/rc.linux.zsh
fi
if [[ $system == 'OSX' ]]; then
	source $DOTFILES_HOME/zsh/rc.osx.zsh
fi

source $DOTFILES_HOME/aliases
source $DOTFILES_HOME/tools

if [[ -f ~/.dir_colors && ( -x /usr/local/bin/dircolors || -x /usr/bin/dircolors ) ]]; then
    eval `dircolors ~/.dir_colors`
fi

if [[ -e ~/.ssh/ssh_auth_sock ]] then
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

compile-zshrc () {
	homesick_repos=$HOME/.homesick/repos
	if [[ -n $1 && $1 == "clean" ]]; then
		find $homesick_repos -name '*.zwc' -delete
		echo 'All *.zwc files removed'
		return
	fi;
	for file in `find $homesick_repos -name '*.zsh' -type f -print`; do
		zcompile $file
	done
}

unset system
unset DOTFILES_HOME