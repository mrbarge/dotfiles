#!/usr/bin/env bash

# Adapted from https://github.com/webpro/dotfiles/blob/master/install.sh

sudo yum install tmux powerline tmux-powerline vim-powerline powerline-fonts 

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR 
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$DOTFILES_DIR" ]; then
	echo "Unable to determine base dotfiles directory."
	exit 1
else
	echo $DOTFILES_DIR
fi

# Update dotfiles itself first
[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Generate a timestamp if we need to backup
backupDate=`date +%s`
if [ -z "$backupDate" ]; then
	echo "Unable to generate backup timestamp value."
	exit 1
fi

# Bunch of symlinks
for f in `find $DOTFILES_DIR/dotfiles/ -maxdepth 1 -a \( -type d -o -type f \)`; do
	basefile=`basename $f`
	dotfile="${HOME}/.${basefile}"

	# Back up what's there
	if [ -a "$dotfile" ]; then
		mv "$dotfile" "$dotfile.$backupDate"
	fi
	ln -sfv "$f" $dotfile
	echo "Deployed $dotfile"
done

mkdir -p $HOME/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/vundle

mkdir -p $HOME/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
