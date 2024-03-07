#!/bin/bash

baseDir=~/projects

if [[ -d "$baseDir" ]]; then
    for program in "$baseDir"/*/; do
    	workingDir=$program
	    cd $workingDir
        if [[ -f "roots.txt" ]]; then
            programName=$(basename "$program")
            echo "Recon for $programName:"
            while read dir; do
                if [[ -d "${program}$dir" ]]; then
                    echo "Running recon on $dir"

                else
                    mkdir "${program}$dir"

                fi
                workingDir=${program}$dir
                cd $workingDir
		

                subfinder -d $dir -silent | anew -q subs.txt
                puredns resolve subs.txt -r ~/tools/wordlists/resolvers/resolvers.txt -w puredns.txt
                cat puredns.txt | anew resolved.txt | notify -silent -bulk -id recon
                rm puredns.txt

            done < roots.txt


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi