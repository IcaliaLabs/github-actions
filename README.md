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

## Docker Stack Deploy

Deploys a Docker stack to a Docker Swarm.

### Example

```
action "Deploy to Docker Swarm" {
  uses = "icalialabs/github-actions/docker-stack-deploy@master"
  env = {
    DOCKER_STACK_DEPLOY_WITH_REGISTRY_AUTH = "yes"
    DOCKER_STACK_DEPLOY_MANAGER_HOSTNAME = "ec2-XX-XXX-XX-XX.some-region.compute.amazonaws.com"
  }
  secrets = [ "DOCKER_STACK_DEPLOY_SSH_KEY" ]
  args = [ "stack-name", "path-to/docker-compose-stack.yml" ]
}
```
