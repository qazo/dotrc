#!/bin/sh

set -e

install_home_files() {
	for file in zshrc zprofile tmux.conf; do
		destfile="${HOME}/.${file}"

		if [ -f "${destfile}" ] || [ -L "${destfile}" ]; then
			echo "${destfile} already exists. removing."
			rm "${destfile}"
		fi
		echo "creating symlink for '${destfile}'"
		ln -s "${PWD}/$file" "${destfile}"
	done
}

install_bin_files() {
	destdir="${HOME}/bin"
	if [ ! -d "${destdir}" ]; then
		mkdir -p "${destdir}"
	fi

	for file in "${PWD}/bin/"*; do
		destfile="${HOME}/bin/$(basename $file)"
			if [ -f "${destfile}" ] || [ -L "${destfile}" ];  then
				echo "${destfile} already exists. removing."
				rm "${destfile}";
			fi
		ln -s "${file}" "${destfile}"
	done
}

install_config_dirs() {
	cp --recursive --no-target-directory {,"${HOME}"/.}config
}

install_home_files;
install_bin_files;
