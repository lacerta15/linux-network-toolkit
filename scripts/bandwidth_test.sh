#!/usr/bin/env bash
# Bandwidth test using iperf3
SERVER="${1:-}"
MODE="${2:-client}"
PORT="${3:-5201}"
if [ "$MODE" = "server" ]; then
    echo "Starting iperf3 server on port $PORT..."
    iperf3 -s -p "$PORT"
elif [ -n "$SERVER" ]; then
    echo "Testing bandwidth to $SERVER:$PORT..."
    iperf3 -c "$SERVER" -p "$PORT" -t 10 -P 4
else
    echo "Usage: $0 <server_ip> [client|server] [port]"
    echo "       $0 server             (start server)"
    echo "       $0 192.168.1.1 client (test from client)"
    echo "Install: yum install iperf3"
fi
