#!/usr/bin/env sh
set -e

DIR=~/Downloads
MIRROR=https://github.com/kubeshark/kubeshark/releases/download

dl()
{
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local platform="${os}_${arch}"
    local file="kubeshark_${ver}_${platform}.tar.gz"
    # https://github.com/kubeshark/kubeshark/releases/download/v51.0.39/kubeshark_51.0.39_darwin_amd64.tar.gz
    local url="$MIRROR/v$ver/${file}"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep -e "${file}" $lchecksums | awk '{ print $1 }')
}

dl_ver() {
    local ver=$1

    # https://github.com/kubeshark/kubeshark/releases/download/v51.0.39/kubeshark_51.0.39_checksums.txt
    local lfile="kubeshark_${ver}_checksums.txt"
    local lchecksums="${DIR}/${lfile}"
    local checksumsurl="${MIRROR}/v${ver}/${lfile}"

    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $checksumsurl
    fi

    printf "  # %s\n" $checksumsurl
    printf "  '%s':\n" $ver
    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums darwin arm64
    dl $ver $lchecksums linux 386
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums windows 386
    dl $ver $lchecksums windows amd64
    dl $ver $lchecksums windows arm64
}

dl_ver ${1:-52.0.0}
