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

                shosubgo -d $dir -s $shodan_key | anew subs.txt | dnsx -silent | anew -q resolved.txt


                

            done < "${program}roots.txt"


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi