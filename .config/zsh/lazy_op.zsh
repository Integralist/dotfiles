#!/usr/bin/zsh

# IMPORTANT: We MUST use MODIFIED_PATH (see notes in ~/.zshrc).
# Otherwise tools like `curl`, `sh` etc can't be found otherwise.
export PATH="$MODIFIED_PATH"

# A Zsh script to provide a lazy-loading function for 1Password secrets,
# with a one-hour cache to speed up shell initialization.

# Define the path for the cache file.
_LAZY_OP_CACHE_FILE="/tmp/cache-lazy-op"

# Delete the cache file if it's older than 60 minutes to ensure secrets are
# periodically refreshed and not stored on disk indefinitely.
# The '2>/dev/null' suppresses errors if the file doesn't exist.
find "$_LAZY_OP_CACHE_FILE" -mmin +60 -delete 2>/dev/null

# Ensure the cache file exists. 'touch -a' creates it if it's missing
# but doesn't modify it if it exists, preserving the modification time.
touch -a "$_LAZY_OP_CACHE_FILE"

# Defines the main function for lazy-loading secrets.
# Usage: lazy_op <ENV_VAR_NAME> <OP_PATH>
lazy_op() {
    if [[ $# -ne 2 ]]; then
        echo "lazy_op: usage: lazy_op <ENV_VAR_NAME> <OP_PATH>" >&2
        return 1
    fi

    local env_var_name="$1"
    local op_path="$2"
    local secret_value

    # Attempt to retrieve the secret from the cache file.
    local cached_line
    cached_line=$(grep "^${env_var_name}=" "$_LAZY_OP_CACHE_FILE")

    if [[ -n "$cached_line" ]]; then
        # CACHE HIT: The key was found in the cache.
        # Extract the value using shell parameter expansion for efficiency.
        secret_value="${cached_line#*=}"
    else
        # CACHE MISS: The key was not found. Fetch from 1Password.
        if ! command -v op &> /dev/null; then
            echo "lazy_op: 'op' command-line tool is not installed or not in PATH." >&2
            return 1
        fi

        # Read the secret from 1Password.
        secret_value=$(op read "$op_path")
        local op_exit_code=$?

        if [[ $op_exit_code -ne 0 ]]; then
            echo "lazy_op: 'op read' command failed for $op_path" >&2
            return $op_exit_code
        fi

        # Store the newly fetched secret in the cache file.
        echo "${env_var_name}=${secret_value}" >> "$_LAZY_OP_CACHE_FILE"
    fi

    # Export the environment variable with the secret value.
    export "$env_var_name"="$secret_value"
}
