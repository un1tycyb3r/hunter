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

                puredns bruteforce ~/tools/wordlists/subs/subs.txt $dir --resolvers ~/tools/wordlists/resolvers/resolvers.txt -w brute1.txt < /dev/null
                puredns bruteforce ~/tools/wordlists/subs/all.txt $dir --resolvers ~/tools/wordlists/resolvers/resolvers.txt -w brute2.txt < /dev/null
                cat brute*.txt | anew resolved.txt
                rm brute*.txt


                

            done < "${program}roots.txt"


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi