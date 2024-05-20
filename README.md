# asrep-roaster

## Description

The `asrep-roaster.sh` script is a tool used for roasting AS-REP hashes in Active Directory environments. It automates the process of requesting and cracking AS-REP hashes, which can be used for privilege escalation and lateral movement in a network.

The script leverages the Impacket suite to extract AS-REP hashes from Active Directory and then cracks them using Hashcat. It automates this process to retrieve plaintext passwords from AS-REP hashes.

## Features

- Automated extraction of AS-REP hashes from Active Directory.
- Integrated hash cracking with Hashcat.

## Prerequisites

- Impacket v0.11.0
- Hashcat
- You will need to know the domain and have a list of usernames to run against the target AD environment. Enumerate as much as you can in other parts of the network if necessary (HTTP, FTP, SMB, nlockmgr, etc.)

## Usage

Give permission to execute.
```bash
chmod +x asrep-roaster.sh
```

Example:
```bash
./asrep-roaster.sh example.com 10.10.10.1 /usr/share/wordlists/usernames.txt
```

## Found hashes but they didn't crack?

Try running hashcat against the hashes using a different wordlist or rule set, like:
```bash
hashcat -m 18200 hashes.asreproast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force --show
```
