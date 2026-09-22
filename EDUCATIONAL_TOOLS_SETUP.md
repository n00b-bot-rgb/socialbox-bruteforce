# Educational Cybersecurity Tools: Installation & Setup (Ubuntu/Linux)

This guide covers legal, educational setup for:

- **Wireshark**: GUI packet/protocol analyzer
- **tcpdump**: CLI packet capture
- **Nmap**: Network mapper and port scanner
- **Scapy**: Python packet crafting/manipulation library
- **tshark**: Wireshark CLI analyzer

## Legal and Ethical Use

Use these tools **only** on systems and networks you own or are explicitly authorized to test (for example, your own lab VM network). Unauthorized scanning or packet capture may violate laws and policies.

## 1) Install on Ubuntu/Linux

```bash
sudo apt-get update
sudo apt-get install -y wireshark tcpdump nmap tshark python3 python3-scapy
```

Optional: allow non-root packet capture with Wireshark:

```bash
sudo usermod -aG wireshark "$USER"
```

Then log out and log back in so new group membership is applied.

## 2) Basic Educational Usage

### Wireshark
What it does: Decodes packet structures and protocol fields for learning network behavior.

```bash
wireshark
```

Example exercise: capture traffic on your local interface and inspect DNS, TCP handshake, and HTTP headers in a lab environment.

Official docs: https://www.wireshark.org/docs/

### tcpdump
What it does: Captures packets in terminal for quick protocol visibility and filtering.

```bash
sudo tcpdump -i any -c 20
sudo tcpdump -i any port 53 -nn
```

Official docs: https://www.tcpdump.org/manpages/tcpdump.1.html

### Nmap
What it does: Maps hosts/services and helps learn network exposure in authorized environments.

```bash
nmap -sn <your-lab-subnet>/24
nmap -sV localhost
```

Replace `<your-lab-subnet>` with your authorized lab network range.

Official docs: https://nmap.org/docs.html

### Scapy
What it does: Python framework to craft, inspect, and analyze packets for protocol learning.

```bash
python3 -c "from scapy.all import IP, ICMP; p=IP(dst='127.0.0.1')/ICMP(); print(p.summary())"
```

Official docs: https://scapy.readthedocs.io/

### tshark
What it does: Command-line Wireshark dissector for scripting and terminal workflows.

```bash
tshark -D
tshark -i any -a duration:5
```

Official docs: https://www.wireshark.org/docs/man-pages/tshark.html

## 3) Installation Verification Script

Run:

Run it from the repository root:

```bash
chmod +x verify_educational_tools.sh
./verify_educational_tools.sh
```

Expected result: reports each tool as installed and confirms Scapy Python import (`from scapy.all import IP, ICMP`) using `python3`.
