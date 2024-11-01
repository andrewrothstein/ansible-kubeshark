#!/usr/bin/env sh
set -e
MIRROR=https://github.com/kubeshark/kubeshark/releases/download

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local platform="${os}_${arch}"
    # https://github.com/kubeshark/kubeshark/releases/download/v52.3.68/kubeshark_darwin_amd64.sha256
    local url="$MIRROR/v$ver/kubeshark_${platform}.sha256"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(curl -SsLf $url | awk '{ print $1; }')
}

dl_ver()
{
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver linux amd64
    dl $ver linux arm64
}

dl_ver ${1:-52.3.87}
