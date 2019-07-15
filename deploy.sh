#!/bin/bash

COLOR_START='\033[0;32m'
COLOR_START_2='\033[0;31m'
COLOR_END='\033[0m'

msg="Deploying updates to GitHub..."
echo -e "${COLOR_START}$msg${COLOR_END}"

if [ "`git status -s`" ]
then
	msg="The working directory is dirty. Please commit any pending changes."
	echo -e "${COLOR_START_2}$msg${COLOR_END}"
    exit 1;
fi

msg="Deleting old publication"
echo -e "${COLOR_START}$msg${COLOR_END}"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

msg="Checking out gh-pages branch into public"
echo -e "${COLOR_START}${msg}${COLOR_END}"
git worktree add -B gh-pages public origin/gh-pages
if [ $? -gt 0 ]; then
	msg="error adding worktree"
	echo -e "${COLOR_START_2}$msg${COLOR_END}"
    exit 1;
fi



msg="Removing existing files"
echo -e "${COLOR_START}${msg}${COLOR_END}"
rm -rf public/*

msg="Generating site"
echo -e "${COLOR_START}${msg}${COLOR_END}"
hugo

msg="Updating gh-pages branch"
echo -e "${COLOR_START}${msg}${COLOR_END}"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
git push --all