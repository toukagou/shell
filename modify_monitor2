#!/bin/bash

monitor_directory() {
    local dir="$1"
    local log_filename="$2"

    echo "DateTime,Event,Directory,FileName" >> "$log_filename"

    inotifywait -r -m -e access,create,delete,modify --timefmt "%y-%m-%d %H:%M" --format "%T %e %w %f" --exclude ".*.swp$|.*.swpx$|.*.swx$|.*~$|4913" "$dir" | while read -r date time event modify_dir modify_file;
    do
        event=${event//,IS/}
        echo "$date $time,$event,$modify_dir,$modify_file" >> "$log_filename"
    done
}

main() {
    local directory="$1"
    local log_filename="$2"
    if [ ! -d "$directory" ]; then
        echo "目录不存在: $directory"
        exit 1
    fi

    local abs_directory="$(realpath "$directory")"
    echo "监控目录: $abs_directory"

    monitor_directory "$abs_directory" "$log_filename"
}

main "$@" "$@"
