# Step 1: Use Docker official 'dind' image as base, so we can be able to execute
# the output of `aws ecr get-login`:
FROM docker:dind

# Step 2: Define the aws CLI version:
ENV AWS_CLI_VERSION=1.16.88

# Step 3: Install aws CLI runtime dependencies:
RUN apk add --no-cache groff less mailcap python2

# Step 4: Install aws CLI:
RUN apk add --no-cache --virtual .build-deps py2-pip \
 && pip install --upgrade awscli==${AWS_CLI_VERSION} \
 && apk del --no-network .build-deps

# Step 5: Set the aws CLI executable as the entrypoint:
ENTRYPOINT [ "aws" ]
