#!/usr/bin/env bash

if ! which go &>/dev/null; then
	echo "Golang not install yet"
else
	echo "Golang installed. Checking..."
	release=($(wget -qO- "https://golang.org/VERSION?m=text"))
	release_version=${release[0]}
	version=$(go tool dist version)

	if [[ "$version" == "$release_version"* ]]; then
		echo "The local Go version ${release_version} is up-to-date."
		exit 0
	else
		echo "The local Go version is ${version}. A new release ${release_version} is available."
	fi
fi

release_file="${release_version}.linux-amd64.tar.gz"

tmp=$(mktemp -d)
cd $tmp || exit 1

echo "Downloading https://go.dev/dl/$release_file ..."
curl -OL https://go.dev/dl/$release_file

[[ -d ${HOME}/apps ]] || mkdir ${HOME}/apps
[[ -d ${HOME}/go ]] || rm -f ${HOME}/go 2>/dev/null

tar -C ${HOME}/apps -xzf $release_file
rm -rf $tmp

mv ${HOME}/apps/go ${HOME}/apps/$release_version
ln -sf ${HOME}/apps/$release ${HOME}/go

version=$(go tool dist version)
echo "Now, local Go version is $version"
