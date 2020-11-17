#!/bin/sh

env=${ENV:="production"}
URL_BASE="https://bearer-cli-binaries.s3.eu-west-1.amazonaws.com"
BINARY_NAME="bearer-cli-latest"
blue="\033[34m"
reset="\033[0m"
red="\033[31m"
green="\033[32m"
os="$(uname -s | awk '{print tolower($0)}')"
arch="$(uname -p | awk '{print tolower($0)}')"

warn() { echo -e "$1" >/dev/stderr ;}
alert() { warn "$red$1$reset" ;}
info() { warn "$green$1$reset" ;}
notice() { warn "$blue$1$reset" ;}

if [ $os = 'darwin' ]; then
  case $arch in
  "i386")
    DOWNLOAD_URL="$URL_BASE/$os/$env/386/bin/$BINARY_NAME"
  ;;
  "x86_64")
    DOWNLOAD_URL="$URL_BASE/$os/$env/amd64/bin/$BINARY_NAME"
  ;;
  *)
    notice "Your system ($os => $arch) is not yet supported"
    exit
  ;;
  esac
fi

if [ $os = 'linux' ]; then
  arch="$(uname -m | awk '{print tolower($0)}')"
  case $arch in
  "i386")
    DOWNLOAD_URL="$URL_BASE/$os/$env/386/bin/$BINARY_NAME"
  ;;
  "x86_64")
    DOWNLOAD_URL="$URL_BASE/$os/$env/amd64/bin/$BINARY_NAME"
  ;;
  "aarch64")
    DOWNLOAD_URL="$URL_BASE/$os/$env/arm64/bin/$BINARY_NAME"
  ;;
  *)
    notice "Your system ($os => $arch) is not yet supported"
    exit
  ;;
  esac
fi

downloadBinary() {
  notice "Downloading to ~/.bearer/bearer-cli"
  mkdir -p ~/.bearer
  curl $DOWNLOAD_URL --output ~/.bearer/bearer-cli
  chmod u+x  ~/.bearer/bearer-cli
}


set -e

downloadBinary
notice " \
Please visit https://github.com/Bearer/scanner-poc/blob/main/README.md#how-to-use-it \
for the binary usage
"