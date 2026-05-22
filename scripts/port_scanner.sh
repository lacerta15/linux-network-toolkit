#!/usr/bin/env bash
# Check connectivity to specific ports on one or more hosts
# Usage: ./port_scanner.sh host1 host2 -- 22 80 443 8080
HOSTS=(); PORTS=(); STAGE=hosts
for arg in "$@"; do
    [ "$arg" = "--" ] && STAGE=ports && continue
    [ "$STAGE" = "hosts" ] && HOSTS+=("$arg") || PORTS+=("$arg")
done
[ ${#HOSTS[@]} -eq 0 ] && HOSTS=(localhost)
[ ${#PORTS[@]} -eq 0 ] && PORTS=(22 80 443 3306 5432 7180 8088 10000)
echo "=== Port Connectivity Check ==="
printf "%-20s" "Host/Port"
for port in "${PORTS[@]}"; do printf " %6s" "$port"; done; echo ""
printf "%-20s" "---"
for port in "${PORTS[@]}"; do printf " %6s" "------"; done; echo ""
for host in "${HOSTS[@]}"; do
    printf "%-20s" "$host"
    for port in "${PORTS[@]}"; do
        timeout 2 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null &&             printf " %6s" "  OPEN" || printf " %6s" "CLOSED"
    done; echo ""
done
