# Deploy Stack to Docker for AWS

## Usage:

```
action "Deploy to Docker Swarm" {
  uses = "icalialabs/github-actions/deploy-stack-to-docker-for-aws@feature/deploy-stack-to-docker-for-aws"
  env = {
    DEPLOY_IMAGES_REQUIRE_AUTH = "yes"
    SWARM_MANAGER_PUBLIC_DNS = "ec2-XX-XXX-XX-XX.some-region.compute.amazonaws.com"
  }
  secrets = [ "DOCKER_FOR_AWS_SSH_KEY" ]
  args = [ "stack-name", "path-to/docker-compose-stack.yml" ]
}
```
