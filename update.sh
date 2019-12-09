#!/usr/bin/env bash

set -eEuo pipefail

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )
distros=( 'alpine3.10' )
apiUrl=https://pypi.org/pypi/Trac/json

for version in "${versions[@]}"; do
	apiJqExpr='
	  ( [.releases | keys[] | select(startswith("'$version'")) ] | sort | .[-1]) as $version
	  | [ $version, (
	      .releases[$version][] | select(.packagetype == "bdist_wheel") |
		.filename, .digests.sha256, .url
	    ) ]
	'

	for distro in "${distros[@]}"; do
		dir="$version/$distro"
		possibles=( $(eval echo "$(curl -fsSL $apiUrl | jq --raw-output "$apiJqExpr | @sh")") )
		if [ "${#possibles[@]}" -eq 0 ]; then
			echo >&2 "error: Unable to determine available release of $version"
			exit 1
		fi
		alpineVer=${distro#alpine}
		version=${possibles[0]}
		filename=${possibles[1]}
		sha256=${possibles[2]}
		url=${possibles[3]}

		mkdir -p "$dir"
		dockerfile="$dir/Dockerfile"
		echo "Generating $dir/Dockerfile from template ..."
		cat ./Dockerfile.template > "$dockerfile"
		cp ./docker-initenv \
			./docker-entrypoint \
			"$dir/"
		(
			set -x;
			sed -ri \
				-e 's|%%ALPINE_VERSION%%|'$alpineVer'|g' \
				-e 's|%%TRAC_VERSION%%|'$version'|' \
				-e 's|%%TRAC_URL%%|'$url'|' \
				-e 's|%%TRAC_URL_FILENAME%%|'$filename'|' \
				-e 's|%%TRAC_SHA256%%|'$sha256'|' \
				"$dockerfile"
		)
	done
done

