#!/usr/bin/env bash
echo "=== Firewall Audit — $(hostname) ==="
if systemctl is-active --quiet firewalld 2>/dev/null; then
    echo "--- firewalld zones ---"
    firewall-cmd --list-all-zones 2>/dev/null | grep -v "^$"
    echo ""
    echo "--- Direct rules ---"
    firewall-cmd --direct --get-all-rules 2>/dev/null
elif systemctl is-active --quiet iptables 2>/dev/null; then
    echo "--- iptables rules ---"
    iptables -L -n -v --line-numbers 2>/dev/null
    echo ""
    echo "--- NAT table ---"
    iptables -t nat -L -n -v 2>/dev/null | head -20
elif command -v nft &>/dev/null; then
    echo "--- nftables ---"
    nft list ruleset 2>/dev/null
else
    echo "[WARN] No firewall found running"
fi
