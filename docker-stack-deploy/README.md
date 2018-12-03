# Docker Stack Deploy

Deploys a Docker stack to a Docker Swarm.

## Usage

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
