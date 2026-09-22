#!/usr/bin/env bash
set -euo pipefail

TOOLS=("wireshark" "tcpdump" "nmap" "tshark" "python3")
MISSING=0
PYTHON_OK=0

echo "Checking educational cybersecurity tool installation..."

for tool in "${TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK] $tool found at $(command -v "$tool")"
    if [ "$tool" = "python3" ]; then
      PYTHON_OK=1
    fi
  else
    echo "[MISSING] $tool not found"
    MISSING=1
  fi
done

if [ "$PYTHON_OK" -eq 1 ]; then
  if python3 -c "from scapy.all import IP, ICMP; p=IP(dst='127.0.0.1')/ICMP(); print(p.summary())" >/dev/null 2>&1; then
    echo "[OK] scapy Python module usage check succeeded with python3"
  else
    echo "[FAILED] scapy Python usage validation command failed for python3"
    MISSING=1
  fi
else
  echo "[SKIP] scapy Python module check skipped because python3 is missing"
fi

if [ "$MISSING" -eq 0 ]; then
  echo "All required educational tools are installed."
  exit 0
fi

echo "One or more tools are missing. See EDUCATIONAL_TOOLS_SETUP.md for installation steps."
exit 1
