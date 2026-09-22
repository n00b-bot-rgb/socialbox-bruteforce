#!/usr/bin/env bash
set -euo pipefail

TOOLS=("wireshark" "tcpdump" "nmap" "tshark" "python3")
MISSING=0
PYTHON_OK=0
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
GUIDE_PATH="$SCRIPT_DIR/EDUCATIONAL_TOOLS_SETUP.md"

echo "Checking educational cybersecurity tool installation..."

for tool in "${TOOLS[@]}"; do
  tool_path="$(command -v "$tool" || true)"
  if [ -n "$tool_path" ]; then
    echo "[OK] $tool found at $tool_path"
    if [ "$tool" = "python3" ]; then
      PYTHON_OK=1
    fi
  else
    if [ "$tool" = "python3" ]; then
      echo "[MISSING] python3 not found (Scapy verification will be skipped)"
    else
      echo "[MISSING] $tool not found"
    fi
    MISSING=1
  fi
done

if [ "$PYTHON_OK" -eq 1 ]; then
  PYTHON_PATH="$(command -v python3)"
  PYTHON_VERSION="$(python3 --version 2>/dev/null || echo 'python3')"
  if ! python3 -c "from scapy.all import IP, ICMP" >/dev/null 2>&1; then
    echo "[MISSING] scapy import failed for $PYTHON_PATH ($PYTHON_VERSION). Install python3-scapy for this interpreter."
    MISSING=1
  elif python3 -c "from scapy.all import IP, ICMP; p=IP(dst='127.0.0.1')/ICMP(); print(p.summary())" >/dev/null 2>&1; then
    echo "[OK] scapy Python module usage check succeeded with python3"
  else
    echo "[FAILED] scapy runtime usage check failed for $PYTHON_PATH ($PYTHON_VERSION)."
    MISSING=1
  fi
else
  echo "[SKIP] scapy Python module check skipped because python3 is missing"
fi

if [ "$MISSING" -eq 0 ]; then
  echo "All required educational tools are installed."
  exit 0
fi

echo "One or more verification checks failed. See the guide below for installation steps."
echo "Guide: $GUIDE_PATH"
exit 1
