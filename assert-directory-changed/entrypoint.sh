#! /bin/sh

# For use on the postgres container only.
set -e

: ${DIRECTORY_TO_ASSERT_CHANGES:=$1}

# Check if directory changed:
git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | \
grep $DIRECTORY_TO_ASSERT_CHANGES && \
export DIRECTORY_CHANGED="YEAH" || \
export DIRECTORY_CHANGED="NO"

if [ "$2" = "fail" ] || [ "$2" = "FAIL" ]
then
  export NEGATIVE_EXIT_CODE=1
else
  export NEGATIVE_EXIT_CODE=78
fi

if [ "$DIRECTORY_CHANGED" = "YEAH" ]
then
  exit 0
else
  exit $NEGATIVE_EXIT_CODE
fi
