#! /bin/sh

# For use on the postgres container only.
set -e

: ${DIRECTORY_TO_ASSERT_CHANGES:=$1}

# Check if directory changed:
git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | \
grep $DIRECTORY_TO_ASSERT_CHANGES && \
export DIRECTORY_CHANGED="YEAH" || \
export DIRECTORY_CHANGED="NO"

if [ "$DIRECTORY_CHANGED" = "YEAH" ]
then
  exit 0
else
  exit 1
fi
