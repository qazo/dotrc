#!/bin/sh


for file in zshrc zprofile tmux.conf; do
	echo "${file}"
	echo cp {,"${HOME}"/.}"${file}"
done
