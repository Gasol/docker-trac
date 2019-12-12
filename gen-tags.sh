#!/usr/bin/env bash

set -eEuo pipefail

convertHttpUrl() {
	local url=$1
	url=${url%.git}
	url=${url/github.com:/github.com/}
	echo "https://${url#git@}"
}

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )
repoUrl=$(git remote get-url origin)
repoHttpUrl=$(convertHttpUrl "$repoUrl")

for version in "${versions[@]}"; do
	distros=( "$version"/*/ )
	distros=( "${distros[@]%/}" )
	distros=( "${distros[@]#*/}" )
	for distro in "${distros[@]}"; do
		dir="$version/$distro"
		if [ ! -d "$dir" ]; then
			continue
		fi
		dockerfile="$dir/Dockerfile"
		if [ ! -f "$dockerfile" ]; then
			continue
		fi
		fullVer=$(sed -ne 's/^ENV TRAC_VERSION=\(.*\)/\1/p' "$dockerfile")
		sha1=$(git rev-list -n 1 HEAD)
		if [ "$version" = "$fullVer" ]; then
			fullVer=
		fi
		printf -- '- ['
		tagVers=( "$version" "$fullVer" )
		for tagVer in "${tagVers[@]}"; do
			if [ -z "$tagVer" ]; then
				continue
			fi
			echo "\`$tagVer-$distro\`"
		done | paste -sd , | tr -d "\n"
		echo "]($repoHttpUrl/blob/$sha1/$dockerfile)"
	done
done

