FROM ubuntu:latest

ARG RUNNER_VERSION="latest"
ARG GITHUB_TOKEN

RUN mkdir -p /opt/runner

WORKDIR /opt/runner

COPY download.sh ./
COPY entrypoint.sh ./
RUN chmod +x ./download.sh ./entrypoint.sh && \
  apt-get update && \
  apt-get install -y sudo curl jq && \
  ./download.sh ${RUNNER_VERSION} ${GITHUB_TOKEN} && \
  tar xf ./actions-runner.tar.gz && \
  useradd github && \
  groupadd docker && \
  usermod -a -G docker github && \
  chown -R github /opt/runner && \
  ./bin/installdependencies.sh && \
  rm actions-runner.tar.gz 

ENTRYPOINT [ "./entrypoint.sh" ]
