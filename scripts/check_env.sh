#!/bin/sh

# Utility script to check if required environment variables are set

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 VAR1 VAR2 VAR3 ..."
    exit 1
fi

# Get required environment variables from arguments
REQUIRED_VARS="$@"

# Check if all required environment variables are set
missing_vars=""

for var in $REQUIRED_VARS; do
    # Indirect variable expansion compatible sh
    eval value=\$$var
    if [ -z "$value" ]; then
        if [ -z "$missing_vars" ]; then
            missing_vars="$var"
        else
            missing_vars="$missing_vars $var"
        fi
    fi
done

# Report results
if [ -z "$missing_vars" ]; then
    echo "✓ All required environment variables are set"
    exit 0
else
    echo "✗ Missing environment variables:"
    for var in $missing_vars; do
        echo "  - $var"
    done
    exit 1
fi