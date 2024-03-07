#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
    
        if [[ -f "${program}roots.txt" ]]; then
            programName=$(basename "$program")
            echo "Recon for $programName:"
            while read dir; do

                workingDir=${program}$dir
                cd $workingDir

                echo "Running host identification on $dir"

                github-subdomains -d coke.com -o gh-subs.txt -t $gh_tokens
                cat gh-subs.txt | anew subs.txt | dnsx -silent | anew -q resolved.txt
                rm gh-subs.txt


                

            done < "${program}roots.txt"


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi