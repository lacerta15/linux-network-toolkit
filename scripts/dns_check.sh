#!/usr/bin/env bash
# Test DNS resolution against all configured resolvers
HOSTS_TO_TEST=("google.com" "$(hostname)" "${@}")
echo "=== DNS Check ==="
echo "Configured resolvers:"
grep "^nameserver" /etc/resolv.conf | awk '{print "  "$2}'
echo ""
for resolver in $(grep "^nameserver" /etc/resolv.conf | awk '{print $2}'); do
    echo "--- Resolver: $resolver ---"
    for host in "${HOSTS_TO_TEST[@]}"; do
        RESULT=$(dig @"$resolver" +short +time=2 "$host" 2>/dev/null | head -1)
        if [ -n "$RESULT" ]; then
            echo "  ✅ $host → $RESULT"
        else
            echo "  ❌ $host → FAILED"
        fi
    done
    echo ""
done
