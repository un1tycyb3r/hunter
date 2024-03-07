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

                naabu -l ips.txt -silent -c 75 | anew naabu.txt


                

            done < "${program}roots.txt"


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi