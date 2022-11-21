# Certificate generation

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

Your root: ABC Company
Your domain: abc.com
Your service: api.abc.com or xyz.abc.com

Step 1: Create root

```bash
cert-gen root -n ABC Company
```
