#!/usr/bin/env bash

set -e

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
DOTBOT_PLUGINS="dotbot_plugins"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse command line options.
DOTBOT_OPTS=""
while getopts "Qqvhd:" opt; do
    case $opt in
    h)
        "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" --help
        exit 1
        ;;
    Q|q|v)
        DOTBOT_OPTS="$DOTBOT_OPTS -$opt"
        ;;
    d)
        DOTBOT_OPTS="$DOTBOT_OPTS -$opt $OPTARG"
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

# Initialize dotbot, and all dotbot plugins.
git submodule update --init --recursive
DOTBOT_PLUGINS_OPTS="-p ${DOTBOT_PLUGINS}/dotbot-omnipkg/omnipkg.py"

for conf in ${@}; do
    "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" ${DOTBOT_PLUGINS_OPTS} ${DOTBOT_OPTS} -c "${conf}"
done