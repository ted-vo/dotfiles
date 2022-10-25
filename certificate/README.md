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
