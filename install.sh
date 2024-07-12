#!/usr/bin/env bash

set -e

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SUFFIX=".yaml"

# Parse command line options.
DOTBOTOPTS=""
while getopts "Qqvd:p:" opt; do
    case $opt in
    Q|q|v)
        DOTBOTOPTS="$DOTBOTOPTS -$opt"
        ;;
    d|p)
        DOTBOTOPTS="$DOTBOTOPTS -$opt $OPTARG"
        ;;
    ?)
        exit 1
        ;;
    esac
done

# Clean up parsed options.
while (( $((OPTIND--)) > 1 )); do
    shift
done

cd "${BASEDIR}"
git submodule update --init --recursive "${DOTBOT_DIR}"

for conf in ${@}; do
    cmd=("${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" ${DOTBOTOPTS} -c "${conf%"-sudo"}${CONFIG_SUFFIX}")

    if [[ $conf == *"sudo"* ]]; then
        cmd=(sudo "${cmd[@]}")
    fi

    "${cmd[@]}"
done