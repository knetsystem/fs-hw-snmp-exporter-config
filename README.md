# FS S5860-20SQ Hardware Info SNMP Exporter Config Generator

Fan, PSU, temperatures and states

This repository provides a reproducible way to generate a Prometheus
[`snmp_exporter`](https://github.com/prometheus/snmp_exporter) configuration
for FS hw equipment.

It uses the official snmp_exporter generator and your custom MIBs to produce
a single file: `fs_hw.yml`.

---

## Requirements

- [Podman](https://podman.io/) (recommended)  

---

## Usage

### 1. Build and generate `fs_hw.yml`

Use Podman’s `--output` option to generate the config file in a safe output folder:

```bash
podman build --output type=local,dest=./output .
```

After the build completes, you will find:

```
./output/fs_hw.yml
```

---

### 2. Using with snmp_exporter

Copy `fs_hw.yml` to your snmp_exporter host and reference it in your service:

```bash
./snmp_exporter --config.file=fs_hw.yml --web.listen-address=:9118
```

---

### 3. Repository Layout

```
.
├── Containerfile     # Multi-stage build that produces fs_hw.yml
├── generator.yml     # Custom generator configuration
├── mibs/             # Directory containing FS MIBs
└── README.md
```

---

## Notes

- This repository does **not** produce a running container image by default.  
- The output file `fs_hw.yml` is ready to use with Prometheus snmp_exporter.  
- Uses Podman for a rootless, reproducible build.  
- The `--output` folder prevents polluting your repository with container files.

---

