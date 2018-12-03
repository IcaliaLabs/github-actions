# Icalia Github Actions

Several custom Github Actions we use

## Assert Path Changed

Used to know if a path (a file or directory) changed during the commit. Our most
common case is triggering builds or not for our monorepositories, based on which
files changed during the commit.

### Example

Given an app exists in the `example-1` directory, with the app code located at
the `example-1/app` directory:

```
action "assert-artanis-changed" {
  uses = "icalialabs/github-actions/assert-path-changed@master"
  args = "example-1/app"
}
```

By default, the result of the action when the directory didn't change will be
neutral. If you need the action to fail, add 'FAIL' to the arguments:

```
action "assert-artanis-changed" {
  uses = "icalialabs/github-actions/assert-path-changed@master"
  args = "example-1/app FAIL"
}
```
