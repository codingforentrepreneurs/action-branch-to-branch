#!/bin/sh -l

git_setup() {
  cat <<- EOF > $HOME/.netrc
		machine github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
		machine api.github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
EOF
  chmod 600 $HOME/.netrc

  git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
  git config --global user.name "$GITHUB_ACTOR"
}

git_setup
git remote update
git fetch --all

git stash

# Will create destination branch if it does not exist
if [[ $( git branch -r | grep "$INPUT_DEST_BRANCH" ) ]]; then
   git checkout "${INPUT_DEST_BRANCH}"
else
   git checkout -b "${INPUT_DEST_BRANCH}"
fi

# Will overwrite INPUT_DEST_BRANCH with INPUT_SOURCE_BRANCH
if [[ "${INPUT_SOURCE_BRANCH}" ]]; then
   git checkout "${INPUT_SOURCE_BRANCH}"
   git branch -D "${INPUT_DEST_BRANCH}"
   git checkout -b "${INPUT_DEST_BRANCH}"
fi

git stash pop
git add .
git commit -m "${INPUT_COMMIT_MESSAGE}"
if [[ "${INPUT_SOURCE_BRANCH}" ]]; then
  # Assumes INPUT_SOURCE_BRANCH on origin has conflicts; thus force.
  git push --set-upstream origin "${INPUT_DEST_BRANCH}" --force
else
  git push --set-upstream origin "${INPUT_DEST_BRANCH}"
fi
