# asrep-roaster

## Description

The `asrep-roaster.sh` script is a tool used for roasting AS-REP hashes in Active Directory environments. It automates the process of requesting and cracking AS-REP hashes, which can be used for privilege escalation and lateral movement in a network.

The script leverages the Impacket suite to extract AS-REP hashes from Active Directory and then cracks them using Hashcat. It automates this process to retrieve plaintext passwords from AS-REP hashes.

## Features

- Automated extraction of AS-REP hashes from Active Directory.
- Integrated hash cracking with Hashcat.

## Prerequisites

- Impacket v0.11.0
- JtR/Hashcat
- Target domain
- A list of the most likely usernames that could be found in the target AD environment

In our use case the usernames were enumerated in other parts of the network from different services (LDAP, HTTP, FTP, SMB, nlockmgr, etc.). 

## Usage

Give permission to execute.
```bash
chmod +x asrep-roaster.sh
```

## Example Output

![image](https://github.com/Br14n41/asrep-roaster/assets/57382125/b98d4aa5-227f-484d-b219-e3f1f4c65758)

Example:
```bash
./asrep-roaster.sh example.com 10.10.10.1 /usr/share/wordlists/usernames.txt
```

## Found hashes but they didn't crack?

Try running hashcat against the hashes using a different wordlist or rule set, like:
```bash
hashcat -m 18200 hashes.asreproast /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force --show
```
