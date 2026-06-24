#!/bin/bash

# ixp-mesh-tester-2025
# A tool for benchmarking network latency and hop counts between East African IXPs.

set -e

# Configuration: IXP Target Endpoints (Common Peering LAN IPs or Looking Glass IPs)
# Format: "Name|IP"
IXP_TARGETS=(
    "KE-IX (Nairobi, Kenya)|196.216.156.1"
    "UIXP (Kampala, Uganda)|196.10.165.1"
    "TIX (Dar es Salaam, Tanzania)|196.216.160.1"
    "RINEX (Kigali, Rwanda)|196.216.168.1"
    "DE-CIX (Nairobi, Kenya)|185.1.222.1"
    "MOZIX (Maputo, Mozambique)|196.216.172.1"
    "IXP-Ethiopia (Addis Ababa)|196.188.25.1"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check dependencies
check_deps() {
    for cmd in ping traceroute bc; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${RED}Error: $cmd is not installed.${NC}"
            exit 1
        fi
    done
}

show_header() {
    echo -e "${BLUE}==============================================================${NC}"
    echo -e "${YELLOW}         East African IXP Mesh Tester - 2025             ${NC}"
    echo -e "${BLUE}==============================================================${NC}"
    echo -e "Timestamp: $(date)"
    echo -e "Source: $(hostname -f) [$(curl -s https://ifconfig.me/ip || echo "Unknown IP")]"
    echo -e "--------------------------------------------------------------"
    printf "%-25s | %-15s | %-8s | %-5s\n" "IXP Target" "IP Address" "Lat(ms)" "Hops"
    echo -e "--------------------------------------------------------------"
}

run_benchmark() {
    local output_file="benchmark_$(date +%Y%m%d_%H%M%S).csv"
    echo "Target,IP,Latency_ms,Hop_Count" > "$output_file"

    for entry in "${IXP_TARGETS[@]}"; do
        IFS="|" read -r name ip <<< "$entry"
        
        # Latency (Avg of 3 pings)
        ping_res=$(ping -c 3 -W 2 "$ip" 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
        
        if [ -z "$ping_res" ]; then
            latency="TIMEOUT"
            hops="N/A"
            color=$RED
        else
            latency=$ping_res
            # Hop count using traceroute
            hops=$(traceroute -m 25 "$ip" 2>/dev/null | tail -n 1 | awk '{print $1}')
            color=$GREEN
        fi

        printf "${color}%-25s${NC} | %-15s | %-8s | %-5s\n" "$name" "$ip" "$latency" "$hops"
        echo "$name,$ip,$latency,$hops" >> "$output_file"
    done
    
    echo -e "--------------------------------------------------------------"
    echo -e "${BLUE}Results saved to: $output_file${NC}"
}

check_deps
show_header
run_benchmark