# Icalia Github Actions

Several custom Github Actions we use

## Assert Directory Changed

Used to know if a directory changed in the commit. Our most common case is
triggering builds or not for our monorepositories, based on which files changed
during the commit.

### Example

Given an app exists in the `example-1` directory, with the app code located at
the `example-1/app` directory:

```
action "assert-artanis-changed" {
  uses = "icalialabs/github-actions/assert-directory-changed@master"
  args = "example-1/app"
}
```
