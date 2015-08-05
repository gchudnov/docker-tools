#!/bin/sh
set -e

# v1.0.1

# The MIT License (MIT)
#
# Copyright (c) 2015 Grigoriy Chudnov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

self=$0

# print an error
fatal () {
  echo "$0:" "$@" >&2
  exit 1
}

# test whether a string contains the given substring
string_contain() { [ -n "$2" ] && [ -z "${2##*$1*}" ]; }

# test for container path
is_container_path() { string_contain ':' "$1"; }

# make directory inside the container
container_mkdir() {
  docker exec "$1" sh -c "[ -d $2 ] || mkdir -p $2"
}

# copy host file to container
container_cp() {
  cmd="docker exec -i $2 sh -c 'cat > $3' < $1"
  eval "$cmd";
}

# transfer file or directory from the host to a container
transfer_host_container() {
  item_base_dir=$1
  item_path=$2
  container_id=$3
  container_dir=$4

  it_dir=''
  if [ -d "$item_path" ]; then
    it_dir=$item_path
  elif [ -f "$item_path" ]; then
    it_dir=$(dirname "$item_path")
    it_file=$(basename "$item_path")
  fi

  if [ "$it_dir" ]; then
    dst_dir="$container_dir"${it_dir##*$item_base_dir}
    container_mkdir "$container_id" "$dst_dir"

    if [ -f "$item_path" ]; then
      dst_path="$dst_dir/$it_file"
      container_cp "$item_path" "$container_id" "$dst_path"
    fi
  fi
}

# copy CONTAINER:PATH -> HOSTPATH
copy_container_host() {
  docker cp "$1" "$2"
}

# copy HOSTPATH -> CONTAINER:PATH22
copy_host_container() {
  src_path=$1
  dst_container=${2%%:*}
  dst_path=${2##*:}

  if [ -f "$src_path" ]; then
    transfer_host_container $(dirname "$src_path") "$src_path" "$dst_container" "$dst_path"
  elif [ -d "$src_path" ]; then
    dst_path=$dst_path'/'$(basename "$src_path")
    find "$src_path" -print0 | xargs -0 bash -c '. $0 --source-only; for it; do transfer_host_container '"$src_path"' $it '"$dst_container"' '"$dst_path"'; done;' "$self"
  else
    fatal "path $src_path not found"
  fi
}

# copy CONTAINER1:PATH -> CONTAINER2:PATH
copy_container_container() {
  tmp_dir=$(mktemp -d)
  copy_container_host "$1" "$tmp_dir"
  copy_host_container "$tmp_dir"'/'$(basename "$1") "$2"
  rm -r "$tmp_dir"
}

usage() {
  script=$(basename "$0")
  echo "Usage: $script [OPTIONS] SOURCE DESTINATION

Copies files and directories between running containers and the host

Patterns:
  $script CONTAINER:PATH HOSTPATH
  $script HOSTPATH CONTAINER:PATH
  $script CONTAINER1:PATH CONTAINER2:PATH

Examples:
* CONTAINER:PATH -> HOSTPATH
  $script kickass_yonath:/home/data.txt .
    - Copies '/home/data.txt' from 'kickass_yonath' container to the current host directory

* HOSTPATH -> CONTAINER:PATH
  $script ./test.txt kickass_yonath:/home/e1/e2
    - Copies 'test.txt' from the current host directory to '/home/e1/e2' in the 'kickass_yonath' container

  $script /home/user/Downloads/test.txt kickass_yonath:/home/e1/e2
    - Copies 'test.txt' from the host directory to '/home/e1/e2' in the 'kickass_yonath' container

  $script /home/user/Downloads kickass_yonath:/home/d1/d2
    - Copies the entire 'Downloads' directory to '/home/d1/d2' in the 'kickass_yonath' container

* CONTAINER1:PATH -> CONTAINER2:PATH
  $script kickass_yonath:/home ecstatic_colden:/
    - Copies the entire 'home' directory from 'kickass_yonath' to 'ecstatic_colden'

  $script kickass_yonath:/home/data.txt ecstatic_colden:/
    - Copies 'data.txt' file from 'kickass_yonath' conrainer to the 'ecstatic_colden' container

Options:
    -h       Display this help message
"
}

main() {
  # parse options
  while getopts ':h:' option; do
    case "${option}" in
      h) usage
         exit
         ;;
     \?) fatal "Invalid option: -$OPTARG"
         exit
         ;;
    esac
  done
  shift $((OPTIND - 1))

  # check arguments
  if [ $# -eq 0 ]; then
    usage
    exit
  fi

  # run
  src=$1
  dst=$2

  if [ -n "$src" ] && [ -n "$dst" ]; then
    if is_container_path "$src"; then
      if is_container_path "$dst"; then
        copy_container_container "$src" "$dst"
      else
        copy_container_host "$src" "$dst"
      fi
    else
      if is_container_path "$dst"; then
        copy_host_container "$src" "$dst"
      else
        fatal "cannot copy files/folders from a host path to a host path"
      fi
    fi
  else
    usage
  fi
}

if [ "$1" != "--source-only" ]; then
  main "${@}"
fi
