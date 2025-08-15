# Stage 1: Build generator and produce snmp.yml
FROM docker.io/golang:latest AS generator

# Install required tools for generator build
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      build-essential \
      libsnmp-dev \
      unzip \
      git \
      make

# Force Net-SNMP to load all MIBs
ENV MIBS=+ALL
ENV MIBDIRS=/build/snmp_exporter/generator/mibs

# Fetch the official snmp_exporter repository (latest)
WORKDIR /build
RUN git clone --depth=1 https://github.com/prometheus/snmp_exporter.git

# Build generator and fetch MIBs in one step
WORKDIR /build/snmp_exporter/generator
RUN make generator

# Copy your custom generator config and FS MIB
COPY generator.yml .
COPY mibs/ ./mibs/

# Generate snmp.yml and rename it directly into container root
RUN ./generator generate && mv snmp.yml /fs_hw.yml

# Stage 2: artifact-only image
FROM scratch AS artifact
COPY --from=generator /fs_hw.yml /
