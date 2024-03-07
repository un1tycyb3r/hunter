import subprocess


def run_script(script_name):
    

    try:
        result = subprocess.run(["zsh", script_name], capture_output=True, text=True)
        if result.returncode != 0:
            print(f'error in {script_name}: {result.stderr}')
            return None
        
        return result.stdout
    
    except Exception as e:
        print(f'Exception running {script_name}: {e}')
        return None
    

def success():

    command1 = ["echo", "Recon Successful. Ready for webserver enumeration. Please run webserver enumeration!"]
    
    try:

        result1 = subprocess.run(command1, capture_output=True, text=True, check=True)
        output1 = result1.stdout

        command2 = ["notify", "-id", "recon"]

        result2 = subprocess.run(command2, input=output1, capture_output=True, text=True, check=True)
        output2 = result2.stdout


    except subprocess.CalledProcessError as e:
        print(f'Command {e.cmd} failed with return code {e.returncode}')

    except Exception as e:
        print(f'An error occured: {e}')


def main():
    domains_sh = run_script("domains.sh")
    if domains_sh:
        shosubgo_sh = run_script("shosubgo.sh")
        if shosubgo_sh:
            github_sh = run_script("github.sh")
            if github_sh:
                ips_sh = run_script("ips.sh")
                if ips_sh:
                    naabu_sh = run_script("naabu.sh")
                    if naabu_sh:
                        brute_sh = run_script("brute.sh")
                        if brute_sh:
                            alt_sh = run_script("alt.sh")
                            if alt_sh:
                                success()
                                    



if __name__ == "__main__":
    main()
    