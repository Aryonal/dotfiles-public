#!/bin/bash
# Universal FZF previewer

# Parse arguments
if [ $# -eq 1 ]; then
    # Single argument mode (for CTRL-T and git status)
    target="$1"
    mode="file"
elif [ $# -eq 2 ]; then
    # Two argument mode (for ripgrep with file:line)
    target="$1"
    line="$2"
    mode="line"
else
    echo "Usage: $0 <file> [line_number]"
    exit 1
fi

# Handle directories
if [ -d "$target" ]; then
    ls -la --color=always "$target"
    exit 0
fi

# Handle regular files
if [ -f "$target" ]; then
    # Check if it's a binary file
    if file --mime "$target" | grep -q binary; then
        echo "$target is a binary file"
        exit 0
    fi

    # Bat preview mode
    if [ "$mode" = "line" ] && [ -n "$line" ]; then
        # Line highlighting mode with context
        if [ "$line" -gt 5 ]; then
            start=$((line - 5))
        else
            start=1
        fi
        end=$((line + 45))
        bat --style=numbers,changes --color=always --highlight-line "$line" --line-range "$start:$end" "$target" 2>/dev/null
    else
        # Regular file preview
        bat --style=numbers,changes --color=always --line-range :500 "$target" 2>/dev/null
    fi

    # Fallback to cat if bat fails
    if [ $? -ne 0 ]; then
        cat "$target"
    fi
else
    echo "Unable to preview: $target"
fi
