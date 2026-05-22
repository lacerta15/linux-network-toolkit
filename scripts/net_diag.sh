#!/usr/bin/env bash
echo "=== Network Diagnostic — $(hostname) — $(date) ==="
echo ""
echo "--- Interfaces ---"
ip addr show | grep -E "^[0-9]+:|inet " |     sed 's/^[0-9]*: //' | awk '{printf "  %s\n", $0}'
echo ""
echo "--- Routing ---"
ip route show
echo ""
echo "--- DNS ---"
cat /etc/resolv.conf | grep -v '^#'
echo ""
echo "--- Connections ---"
ss -tuln | head -30
echo ""
echo "--- Connectivity Tests ---"
for target in 8.8.8.8 1.1.1.1; do
    ping -c2 -W2 "$target" &>/dev/null && echo "  ✅ $target reachable" || echo "  ❌ $target unreachable"
done
echo ""
echo "--- Network Stats ---"
netstat -s 2>/dev/null | grep -E "segments|errors|retransmit" | head -10 ||     ss -s | head -10
