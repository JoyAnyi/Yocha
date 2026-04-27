#!/bin/sh
printf '\033c\033]0;%s\a' Yocha
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Yocha.x86_64" "$@"
