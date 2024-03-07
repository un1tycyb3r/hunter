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
		

                tew -i naabu.txt -dnsx dns.json -vhost | httpx -sc -title -cl -web-server -location -no-color -follow-redirects -t 15 -no-fallback -probe-all-ips -random-agent -o $dir.txt -oa
                rm dns.json

            done < roots.txt


        else
            programName=$(basename "$program")
            echo "No root domains found for $programName"
        fi
    done
fi