# Shells support my jobs

<detail>
<summary>Certificate generation</summary>

## ROOT CA

- Shell script for generation certificates and key SSL/TLS
- Usage:

```bash
  "cert-gen root"
  " "
  "Available Commands:"
  ""
  "Flags:"
  " -h, --help show brief help"
  " -n, --company-name company name"
  " -o, --dir-cert output directory"
```

## SIGN SERVICE

- Shell script for signing certificates and key SSL/TLS
- Usage:

```bash
   "cert-gen service"
   " "
   "Available Commands:"
   ""
   "Flags:"
   "  -h, --help               show brief help"
   "  -d, --domain             domain. ex: domain.com or sub.domain.com"
   "  -ca                      input CA crt"
   "  -ca-key                  input CA Key"
   "  -o, --dir-cert           output directory"
```

## Example

You wanna create cert for mTLS in your infra or TLS cert for your domain.

Your root: `ABC Company`
Your domain: `abc.com`
Your service: `api.abc.com` or `xyz.abc.com`

Required: Create root

```bash
cert-gen root -n ABC Company
```

### Create cert for domain `abc.com` or `xyz.abc.com`

```bash
# with abc.crt and abc.key are result of cert-gen root
./cert-gen service -d abc.com -ca abc.crt -ca-key abc.key
```

```bash
# with abc.crt and abc.key are result of cert-gen root
./cert-gen service -d xyz.abc.com -ca abc.crt -ca-key abc.key
```
</detail>

<detail>
<summary>gcp-shell</summary>

```bash
shell script for run sql auth proxy client

usage:
gcp-cloud-proxy [flag] => flag for fast connect mode
gcp-cloud-proxy        => without flag for selection mode

available commands:

flags:
  -h, --help                show brief help
  -c, --connection-name     projectid:region:instanceid
  -p, --port                port local for forwarding

```
</detail>

<detail>
<summary> Shell build | publish helm-chart to Gitlab Registry</summary>

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
</detail>
