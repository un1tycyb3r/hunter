#!/bin/bash

source ~/.profile
url=$1

read -p "Target Company: " target

if
[ ! -d "/bbh" ]; then
mkdir /bbh
fi

if
[ ! -d "/bbh/$target" ]; then
mkdir /bbh/$target
fi

if
[ ! -d "/bbh/$target/$url" ]; then
mkdir /bbh/$target/$url
fi

if
[ ! -d "/bbh/$target/$url/recon" ]; then
mkdir /bbh/$target/$url/recon
fi

if
[ ! -d "/bbh/$target/$url/recon/subs" ]; then
mkdir /bbh/$target/$url/recon/subs
fi

if
[ ! -d "/bbh/$target/$url/recon/scans" ]; then
mkdir /bbh/$target/$url/recon/scans
fi

if
[ ! -d "/bbh/$target/$url/recon/httprobe" ]; then
mkdir /bbh/$target/$url/recon/httprobe
fi

if
[ ! -d "/bbh/$target/$url/recon/gau" ]; then
mkdir /bbh/$target/$url/recon/gau
fi

if
[ ! -d "/bbh/$target/$url/recon/extensions" ]; then
mkdir /bbh/$target/$url/recon/extensions
fi

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with assetfinder...."
echo '------------------------------------------------------------------------'

echo $url | assetfinder --subs-only | anew /bbh/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with amass...."
echo '------------------------------------------------------------------------'

amass enum -d $url | anew /bbh/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with subfinder...."
echo '------------------------------------------------------------------------'

subfinder -d $url | anew /bbh/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Hunting subdomains with github-subdomains...."
echo '------------------------------------------------------------------------'

github-subdomains -d $url -t '<api key here>' | anew /bbh/$target/$url/recon/subs/$url-subs

echo '------------------------------------------------------------------------'
echo " [+] Testing subs with httprobe...."
echo '------------------------------------------------------------------------'

cat /bbh/$target/$url/recon/subs/$url-subs | httprobe | anew /bbh/$target/$url/recon/httprobe/$url-verified

echo '------------------------------------------------------------------------'
echo " [+] Searching for open ports with naabu...."
echo '------------------------------------------------------------------------'

cat /bbh/$target/$url/recon/httprobe/$url-verified | sed 's/https\?:\/\///' | naabu -nmap-cli 'nmap -sV -oG nmap-output' | anew /bbh/$target/$url/recon/scans/$url-alive-portscan

echo '------------------------------------------------------------------------'
echo " [+] Scraping data from the time machine...."
echo '------------------------------------------------------------------------'

cat /bbh/$target/$url/recon/httprobe/$url-verified | gau >> /bbh/$target/$url/recon/gau/$url-gau.txt
sort -u /bbh/$target/$url/recon/gau/$url-gau.txt

echo '------------------------------------------------------------------------'
echo " [+] We trying to find all them params from the time machine now...."
echo '------------------------------------------------------------------------'

cat /bbh/$target/$url/recon/gau/$url-gau.txt | grep '?

*=' | cut -d '=' -f 1 | sort -u >> /bbh/$target/$url/recon/gau/$url-gauparams
for line in $(cat /bbh/$target/$url/recon/gau/$url-gau); do echo $line'=';done

echo '-------------------------------------------------------------------------------'
echo " [+] Searching for interesting files in the great, almighty time machine...."
echo '-------------------------------------------------------------------------------'

for line in $(cat /bbh/$target/$url/recon/gau/$url-gau.txt);do
ext="${line##*.}"


    if [[ "$ext" == "js" ]]; then
        echo $line >> /bbh/$target/$url/recon/gau/$url-js1.txt
        sort -u /bbh/$target/$url/recon/gau/$url-js1.txt >> /bbh/$target/$url/recon/gau/$url-js.txt
    fi
    if [[ "$ext" == "html" ]];then
        echo $line >> /bbh/$target/$url/recon/gau/$url-jsp1.txt
        sort -u /bbh/$target/$url/recon/gau/$url-jsp1.txt >> /bbh/$target/$url/recon/gau/$url-jsp.txt
    fi
    if [[ "$ext" == "json" ]];then
        echo $line >> /bbh/$target/$url/recon/gau/$url-json1.txt
        sort -u /bbh/$target/$url/recon/gau/$url-json1.txt >> /bbh/$target/$url/recon/gau/$url-json.txt
    fi
    if [[ "$ext" == "php" ]];then
        echo $line >> /bbh/$target/$url/recon/gau/$url-php1.txt
        sort -u /bbh/$target/$url/recon/gau/$url-php1.txt >> /bbh/$target/$url/recon/gau/$url-php.txt
    fi
    if [[ "$ext" == "aspx" ]];then
        echo $line >> /bbh/$target/$url/recon/gau/$url-aspx1.txt
        sort -u /bbh/$target/$url/recon/gau/$url-aspx1.txt >> /bbh/$target/$url/recon/gau/$url-aspx.txt
    fi
done

rm /bbh/$target/$url/recon/gau/extensions/js1.txt
rm /bbh/$target/$url/recon/gau/extensions/jsp1.txt
rm /bbh/$target/$url/recon/gau/extensions/json1.txt
rm /bbh/$target/$url/recon/gau/extensions/php1.txt
rm /bbh/$target/$url/recon/gau/extensions/aspx1.txt

echo '-------------------------------------------------------------------------------'
echo " [+] They call me the peeping Tom of websites...I take lots of pictures...."
echo '-------------------------------------------------------------------------------'

eyewitness --web -f /bbh/$target/$url/recon/httprobe/$url-verified -d /bbh/$target/$url/recon/eyewitness --resolve
