FROM centos:latest

ARG RUNNER_VERSION="latest"
ARG GITHUB_TOKEN

RUN mkdir -p /opt/runner

WORKDIR /opt/runner

COPY download.sh ./
COPY entrypoint.sh ./
RUN chmod +x ./download.sh ./entrypoint.sh
RUN yum install -y curl jq
RUN ./download.sh ${RUNNER_VERSION} ${GITHUB_TOKEN}
RUN tar xf ./actions-runner.tar.gz
RUN useradd github
RUN chown -R github /opt/runner
RUN ./bin/installdependencies.sh
RUN rm actions-runner.tar.gz

USER github

ENTRYPOINT [ "./entrypoint.sh" ]
