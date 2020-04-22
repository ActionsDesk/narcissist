# ActionsDesk Narcissist

> Self-hosted, self-registering runners for GitHub Actions

## Getting Started

### Building

```
docker build --tag runner:latest --build-arg GITHUB_TOKEN -- .
```

### Running

```
docker run -it --rm --env "GITHUB_TOKEN=$GITHUB_TOKEN" --env "GITHUB_RUNNER_URL=https://github.com/ActionsDesk" -- runner:latest
```
