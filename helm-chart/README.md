# Shell build | publish helm-chart to Gitlab Registry

```bash
Shell script for build or publish helm chart package

Usage:
helmc [command]

Available Commands:
  build       package chart
  publish     publish chart

Flags:
  -h, --help                show brief help
  -v                        set the version on the chart to this semver version
```

## Build

```bash
Build helm chart package

Usage:
helmc build [flags]

Available Commands: None

Flags:
  -c, --chart-dir=DIR       specify a directory of chart path to store input.
  -o, --output-dir=DIR      specify a directory to store output in. Default is current directory.
```

## Publish to Gitlab Registry

```bash
Publish helm chart package

Usage:
helmc publish [flags]

Available Commands: None

Flags:
  -c, --chart-dir=DIR       specify a directory of chart path to store input.
  -p                        specify a project id.
  -u                        username of publisher to gitlab registry.. What ever you want.
  -t                        token (access token) for gitlab registry. Must have permission write registry.
  -o, --output-dir=DIR      specify a directory to store output in. Default is current directory.

```
