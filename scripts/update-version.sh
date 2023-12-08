#!/bin/bash

# Function to update the version string in pubspec.yaml
update_version() {
  local version_string="$1"
  sed -i '' -E "s/^version: .+$/version: $version_string/" pubspec.yaml
}

# Function to commit changes and create a Git tag
git_commit_and_tag() {
  local version_string="$1"
  git add pubspec.yaml
  git commit -m "chore: version $version_string"
  git tag "v$version_string"
}

# Check if a version string is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <new_version>"
  exit 1
fi

# Get the new version string from the command line argument
new_version="$1"

# Update the version in pubspec.yaml
update_version "$new_version"

# Commit changes and create a Git tag
git_commit_and_tag "$new_version"

echo "Version updated to $new_version and Git tag created."
