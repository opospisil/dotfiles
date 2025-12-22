#!/bin/bash
set -euo pipefail

# Default project directory to current directory
project_dir="${1:-.}"

# Check if project directory exists before resolving
if [ ! -d "$project_dir" ]; then
    echo "Error: Directory '$project_dir' does not exist"
    exit 1
fi

# Resolve to absolute path
project_dir=$(realpath "$project_dir")

# Check if image exists
if ! docker image inspect opencode-docker >/dev/null 2>&1; then
    echo "Error: Docker image 'opencode-docker' not found"
    echo "Please build it first by running: ./build.sh"
    exit 1
fi

# Create project-specific hash for isolated sessions
project_hash=$(echo -n "$project_dir" | md5sum | cut -d' ' -f1)
state_dir="$HOME/.local/state/opencode-docker/$project_hash"
share_dir="$HOME/.local/share/opencode-docker/$project_hash"
config_dir="$HOME/.config/opencode-docker/$project_hash"

# Create directories if they don't exist with proper subdirectories
mkdir -p "$state_dir" "$config_dir"
mkdir -p "$share_dir"/{log,bin,storage}

# Ensure auth.json exists in host (create empty if not present)
if [ ! -f "$HOME/.local/share/opencode/auth.json" ]; then
    mkdir -p "$HOME/.local/share/opencode"
    echo '{}' > "$HOME/.local/share/opencode/auth.json"
fi

# Copy global config to project-specific config if it exists and project config is empty
if [ -d "$HOME/.config/opencode" ] && [ -z "$(ls -A "$config_dir" 2>/dev/null)" ]; then
    cp -r "$HOME/.config/opencode/"* "$config_dir/" 2>/dev/null || true
fi

# Run the container with proper mounts
echo "Starting opencode-docker container..."
echo "Project directory: $project_dir"
echo "Config directory: $config_dir"
echo "Session storage: $share_dir"
echo "Network: host (can access localhost services)"

docker run --rm -it \
    --network host \
    -e "USER=opencode" \
    -e "USERNAME=opencode" \
    -e "LOGNAME=opencode" \
    -v "$project_dir:/workspace" \
    -v "$config_dir:/home/opencode/.config/opencode" \
    -v "$HOME/.local/share/opencode/auth.json:/home/opencode/.local/share/opencode/auth.json" \
    -v "$share_dir:/home/opencode/.local/share/opencode/storage" \
    -v "$share_dir/log:/home/opencode/.local/share/opencode/log" \
    -v "$share_dir/bin:/home/opencode/.local/share/opencode/bin" \
    -v "$state_dir:/home/opencode/.local/state/opencode" \
    opencode-docker "${@:2}"
