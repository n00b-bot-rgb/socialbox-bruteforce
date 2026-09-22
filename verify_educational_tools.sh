#!/usr/bin/env bash
set -euo pipefail

TOOLS=("wireshark" "tcpdump" "nmap" "tshark" "python3")
MISSING=0

echo "Checking educational cybersecurity tool installation..."

for tool in "${TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK] $tool found at $(command -v "$tool")"
  else
    echo "[MISSING] $tool not found"
    MISSING=1
  fi
done

if python3 -c "from scapy.all import IP" >/dev/null 2>&1; then
  echo "[OK] scapy Python module import succeeded"
elif [ "$EUID" -ne 0 ] && \
     PYTHONPATH="$(python3 -m site --user-site)${PYTHONPATH:+:$PYTHONPATH}" python3 -c "from scapy.all import IP" >/dev/null 2>&1; then
  echo "[OK] scapy Python module import succeeded (using current user site-packages)"
elif [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ] && \
     SUDO_USER_SITE="$(sudo -H -u "$SUDO_USER" python3 -m site --user-site 2>/dev/null)" && \
     [ -n "$SUDO_USER_SITE" ] && \
     PYTHONPATH="$SUDO_USER_SITE${PYTHONPATH:+:$PYTHONPATH}" python3 -c "from scapy.all import IP" >/dev/null 2>&1; then
  echo "[OK] scapy Python module import succeeded (using sudo invoking user site-packages)"
else
  echo "[MISSING] scapy Python module not available"
  MISSING=1
fi

if [ "$MISSING" -eq 0 ]; then
  echo "All required educational tools are installed."
  exit 0
fi

echo "One or more tools are missing. See EDUCATIONAL_TOOLS_SETUP.md for installation steps."
exit 1
