#!/bin/sh
for dir in "."/*/; do
    if [ -d "$dir" ]; then
        is_git_dir=$(git -C "$dir" rev-parse --is-inside-work-tree 2> /dev/null)
        if [ "$is_git_dir" != "true" ]; then
            continue
        fi
        if git -C "$dir" diff --quiet HEAD -- 2>/dev/null; then
            continue
        fi
        printf "$dir\n";
    fi
done
