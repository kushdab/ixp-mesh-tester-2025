# IXP Mesh Tester 2025

A lightweight Bash-based benchmarking tool designed to measure network performance between East African Internet Exchange Points (IXPs).

## Features
- Latency measurement (ICMP Round Trip Time).
- Hop count tracking via traceroute.
- Pre-configured with major East African IXP peering LAN endpoints (KE-IX, UIXP, TIX, RINEX, etc.).
- CSV export for historical analysis.
- Color-coded CLI output.

## Requirements
- `bash`
- `iputils-ping`
- `traceroute`
- `bc`
- `curl` (optional, for source IP detection)

## Installation
```bash
git clone https://github.com/user/ixp-mesh-tester-2025.git
cd ixp-mesh-tester-2025
chmod +x benchmark.sh
```

## Usage
Run the script with root/sudo privileges (required for traceroute ICMP packets in some environments):
```bash
sudo ./benchmark.sh
```

## Target IXPs Included
- Kenya (KE-IX, DE-CIX Nairobi)
- Uganda (UIXP)
- Tanzania (TIX)
- Rwanda (RINEX)
- Mozambique (MOZIX)
- Ethiopia (IXP-Ethiopia)