#!/bin/bash

source ~/.profile
url=$1

read -p "Target Company: " target

if
[ ! -d "~/projects" ]; then
mkdir ~/projects
fi

if
[ ! -d "~/projects/$target" ]; then
mkdir ~/projects/$target
fi

if
[ ! -d "~/projects/$target/$url" ]; then
mkdir ~/projects/$target/$url
fi

if
[ ! -d "~/projects/$target/$url/recon" ]; then
mkdir ~/projects/$target/$url/recon
fi

if
[ ! -d "~/projects/$target/$url/recon/subs" ]; then
mkdir ~/projects/$target/$url/recon/subs
fi

if
[ ! -d "~/projects/$target/$url/recon/scans" ]; then
mkdir ~/projects/$target/$url/recon/scans
fi

if
[ ! -d "~/projects/$target/$url/recon/httprobe" ]; then
mkdir ~/projects/$target/$url/recon/httprobe
fi

if
[ ! -d "~/projects/$target/$url/recon/gau" ]; then
mkdir ~/projects/$target/$url/recon/gau
fi

if
[ ! -d "~/projects/$target/$url/recon/extensions" ]; then
mkdir ~/projects/$target/$url/recon/extensions
fi

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with assetfinder...."
echo '------------------------------------------------------------------------'

echo $url | assetfinder --subs-only | anew ~/projects/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with amass...."
echo '------------------------------------------------------------------------'

amass enum -d $url | anew ~/projects/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with subfinder...."
echo '------------------------------------------------------------------------'

subfinder -d $url | anew ~/projects/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with github-subdomains...."
echo '------------------------------------------------------------------------'

github-subdomains -d $url -t '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' -o $url-ghsubs 

cat ~/projects/$target/$url/recon/subs/$url-ghsubs | anew ~/projects/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Testing subs with httprobe...."
echo '------------------------------------------------------------------------'

cat ~/projects/$target/$url/recon/subs/$url-subs | httprobe | anew ~/projects/$target/$url/recon/httprobe/$url-verified

echo '------------------------------------------------------------------------'
echo " [+] Searching for open ports with naabu...."
echo '------------------------------------------------------------------------'

cat ~/projects/$target/$url/recon/httprobe/$url-verified | sed 's/https\?:\/\///' | naabu -nmap-cli 'nmap -sV -oG ~/projects/$target/$url/recon/scans/nmap-output' | anew ~/projects/$target/$url/recon/scans/$url-alive-portscan

echo '------------------------------------------------------------------------'
echo " [+] Scraping data from the time machine...."
echo '------------------------------------------------------------------------'

cat ~/projects/$target/$url/recon/httprobe/$url-verified | /usr/local/sbin/bin/gau | anew ~/projects/$target/$url/recon/gau/$url-gau.txt
sort -u ~/projects/$target/$url/recon/gau/$url-gau.txt

echo '------------------------------------------------------------------------'
echo " [+] We trying to find all them params from the time machine now...."
echo '------------------------------------------------------------------------'

cat ~/projects/$target/$url/recon/gau/$url-gau.txt | grep '?

*=' | cut -d '=' -f 1 | sort -u >> ~/projects/$target/$url/recon/gau/$url-gauparams
for line in $(cat ~/projects/$target/$url/recon/gau/$url-gau); do echo $line'=';done

echo '-------------------------------------------------------------------------------'
echo " [+] Searching for interesting files in the great, almighty time machine...."
echo '-------------------------------------------------------------------------------'

for line in $(cat ~/projects/$target/$url/recon/gau/$url-gau.txt);do
ext="${line##*.}"


    if [[ "$ext" == "js" ]]; then
        echo $line >> ~/projects/$target/$url/recon/gau/$url-js1.txt
        sort -u ~/projects/$target/$url/recon/gau/$url-js1.txt >> ~/projects/$target/$url/recon/gau/$url-js.txt
    fi
    if [[ "$ext" == "html" ]];then
        echo $line >> ~/projects/$target/$url/recon/gau/$url-jsp1.txt
        sort -u ~/projects/$target/$url/recon/gau/$url-jsp1.txt >> ~/projects/$target/$url/recon/gau/$url-jsp.txt
    fi
    if [[ "$ext" == "json" ]];then
        echo $line >> ~/projects/$target/$url/recon/gau/$url-json1.txt
        sort -u ~/projects/$target/$url/recon/gau/$url-json1.txt >> ~/projects/$target/$url/recon/gau/$url-json.txt
    fi
    if [[ "$ext" == "php" ]];then
        echo $line >> ~/projects/$target/$url/recon/gau/$url-php1.txt
        sort -u ~/projects/$target/$url/recon/gau/$url-php1.txt >> ~/projects/$target/$url/recon/gau/$url-php.txt
    fi
    if [[ "$ext" == "aspx" ]];then
        echo $line >> ~/projects/$target/$url/recon/gau/$url-aspx1.txt
        sort -u ~/projects/$target/$url/recon/gau/$url-aspx1.txt >> ~/projects/$target/$url/recon/gau/$url-aspx.txt
    fi
done

rm ~/projects/$target/$url/recon/gau/extensions/js1.txt
rm ~/projects/$target/$url/recon/gau/extensions/jsp1.txt
rm ~/projects/$target/$url/recon/gau/extensions/json1.txt
rm ~/projects/$target/$url/recon/gau/extensions/php1.txt
rm ~/projects/$target/$url/recon/gau/extensions/aspx1.txt
