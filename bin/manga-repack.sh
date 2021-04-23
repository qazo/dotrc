#!/bin/bash

# Author: Kwezilomso Mhaga <kwezimhaga@live.com>
# Description: Script that is use when downscaling manga volumes.
# Arguments are passed through env variables instead of argv. Might try using
# getopt but the script works fine as-is now.
# Requirements: 7z, zip, unrar, imagemagick

set -e
cwd="${PWD}"
prog_name=$(basename "${0}")
archive_regex=${archive_regex:-'.+\.\(zip\|cbz\|rar\|cbr\)$'}
image_size="${image_size:-x1800}"
image_qlty="${image_qlty:-85%}"
image_opts="-strip"
image_opts="${image_opts} -quality ${image_qlty}"
image_opts="${image_opts} -resize ${image_size}"
image_regex='.+\.\(png\|jpg\|jpeg\)$'
echo "mogrify opts: ${image_opts}"

function cprint() {
	case "${1}" in
		-green)
			echo -ne "\e[32m"
			;;
		-orange)
			echo -ne "\e[33m"
			;;
		-red)
			echo -ne "\e[31m"
			;;
		-cyan)
			echo -ne "\e[36m"
			;;
		-gray)
			echo -ne "\e[90m"
			;;
		*)
			echo "${@}"
			return 0
			;;
esac
	echo -n "${@:2}"
	echo -e "\e[0m"
}


function find_archive() {
	# variable only used for shortening line length
	find_opts="-maxdepth 1"
	find_opts="${find_opts} -type f"
	find_opts="${find_opts} -regex ${archive_regex}"
	find_opts="${find_opts} -print0"

	find . ${find_opts} | sort --zero-terminated
}

function find_image() {
	# variable only used for shortening line length
	find_opts="-type f"
	find_opts="${find_opts} -regex ${image_regex}"
	find_opts="${find_opts} -print0"

	find . ${find_opts} | sort --zero-terminated
}

find_archive | while read -r -d '' archive; do
	if [ ! -f "${archive}" ]; then
		cprint -gray "skipping ${archive}"
		continue
	fi
	# remove leading './'
	archive=$(echo $archive | sed 's/^\.\///')

	temp_dir="${archive%.*}" # strip extention
	destname=new-$(basename "${temp_dir}").zip
	cprint -cyan ${archive}
	if [ -f "${destname}" ]; then
		cprint -orange "${archive} already complete. Skipping"
		continue
	fi

	rm -rf "${temp_dir}" # remove if exists
	cprint "extracting archive..."
	case "${archive}" in
		*.zip | *.cbz)
			unzip -qd "${temp_dir}" "${archive}"
			;;
		*.rar | *.cbr)
			unrar x "${archive}" "${temp_dir}/" 1>/dev/null
			;;
		*) # add others when needed
			cprint -red "archive '${arvhive}' not supported. Skipping" >&2
			continue
			;;
	esac

	cd "${temp_dir}"
	cprint "rescaling..."

	find_image | while IFS= read -r -d '' image; do
		cprint -gray "${image}..."
		if [ ! -f "${image}" ]; then
			cprint -red "image '${image}' does not exist. script bug?" >&2
		fi
		mogrify ${image_opts} "${image}"
	done

	cprint "zipping ${destname}"
	zip -qrm "../${destname}" ./*
	# 7z.exe a -tzip  -mx0 -sdel "../${destname}" ./*
	cd "${cwd}"
	rm -rf "${temp_dir}"
	rm "${archive}"
done

echo "Done!"
