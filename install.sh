#!/bin/sh


for file in zshrc zprofile tmux.conf; do
	echo "${file}"
	cp {,"${HOME}"/.}"${file}"
done

echo "config"
cp --recursive --no-target-directory {,"${HOME}"/.}config
