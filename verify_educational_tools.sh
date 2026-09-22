#!/usr/bin/env bash
set -euo pipefail

TOOLS=("wireshark" "tcpdump" "nmap" "tshark" "python3")
MISSING=0
PYTHON_BIN="/usr/bin/python3"

if [ ! -x "$PYTHON_BIN" ]; then
  PYTHON_BIN="$(command -v python3)"
fi

echo "Checking educational cybersecurity tool installation..."

for tool in "${TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK] $tool found at $(command -v "$tool")"
  else
    echo "[MISSING] $tool not found"
    MISSING=1
  fi
done

if "$PYTHON_BIN" -c "from scapy.all import IP, ICMP" >/dev/null 2>&1; then
  echo "[OK] scapy Python module import succeeded with $PYTHON_BIN"
else
  echo "[MISSING] scapy Python module not available for $PYTHON_BIN"
  MISSING=1
fi

if [ "$MISSING" -eq 0 ]; then
  echo "All required educational tools are installed."
  exit 0
fi

echo "One or more tools are missing. See EDUCATIONAL_TOOLS_SETUP.md for installation steps."
exit 1
