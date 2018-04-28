#!/bin/sh


for file in zshrc zprofile tmux.conf; do
	echo "${file}"
	cp {,"${HOME}"/.}"${file}"
done
