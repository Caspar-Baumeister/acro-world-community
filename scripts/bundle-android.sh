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
  git commit -m "Version $version_string"
  git tag "v$version_string"
}

# Function to check if the git directory is clean
check_git_clean() {
  if [ -n "$(git status --porcelain)" ]; then
    echo "Error: Git directory is not clean. Commit or discard changes before proceeding."
    exit 1
  fi
}

# Function to run "flutter build appbundle"
build_appbundle() {
  flutter build appbundle
}

# Function to display usage information
display_usage() {
  echo "Usage: $0 [options]"
  echo "Increment the version in pubspec.yaml, create a Git tag, and build an Android App Bundle."
  echo "Options:"
  echo "  -h       Display this help message"
  echo "  major   Increment the major version"
  echo "  minor   Increment the minor version"
  echo "  patch   Increment the patch version (default)"
}

# Function to parse and increment version components
increment_version() {
  local current_version="$1"
  local component="$2"

  # Extract major, minor, and patch versions
  local major=$(echo "$current_version" | cut -d'.' -f1)
  local minor=$(echo "$current_version" | cut -d'.' -f2)
  local patch=$(echo "$current_version" | cut -d'.' -f3 | cut -d'+' -f1)
  local version_code=$(echo "$current_version" | cut -d'+' -f2)

  # Increment the specified component
  case "$component" in
    "major")
      major=$((major + 1))
      minor=0
      patch=0
      ;;
    "minor")
      minor=$((minor + 1))
      patch=0
      ;;
    "patch")
      patch=$((patch + 1))
      ;;
    *)
      echo "Invalid component: $component"
      exit 1
      ;;
  esac

  # Increase versionCode by 1 from the previous versionCode
  version_code=$((version_code + 1))

  # Build the new version string
  local new_version="$major.$minor.$patch+$version_code"
  echo "$new_version"
}

# Check if the script is called with -h
if [ "$1" == "-h" ]; then
  display_usage
  exit 0
fi

# Check if the git directory is clean
check_git_clean

# Determine the version component to increment
if [ -z "$1" ]; then
  # If no arguments are provided, increment the patch version by default
  component="patch"
else
  component="$1"
fi

# Get the current version from pubspec.yaml
current_version=$(grep "^version: " pubspec.yaml | cut -d' ' -f2)

# Increment the specified version component
new_version=$(increment_version "$current_version" "$component")

# Update the version in pubspec.yaml
update_version "$new_version"

# Commit changes and create a Git tag
git_commit_and_tag "$new_version"

# Run "flutter build appbundle"
build_appbundle

echo "Version updated to $new_version, Git tag created, and Android App Bundle built."
