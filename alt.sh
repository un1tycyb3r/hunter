#!/bin/bash

# Set Path Variables
export GOROOT=/usr/local/go
export GOPATH=/root/go
export PATH=/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:/root/go/bin:/root/.cargo/bin:/root/.local/bin

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
    
        if [[ -f "${program}roots.txt" ]]; then
            programName=$(basename "$program")
            echo "Recon for $programName:"
            while read dir; do

                workingDir=${program}$dir
                cd $workingDir

                echo "Identifying Interesting Endpoints for $dir"

                cat subs.txt | dnsgen - | puredns resolove -r ~/tools/wordlists/resolvers/resolvers.txt -w puredns.txt
                cat puredns.txt | anew resolved.txt
                rm puredns.txt


                

            done < "${program}roots.txt"


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi