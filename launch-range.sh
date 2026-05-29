#!/usr/bin/env bash
#################################################################################
# SYSTEM AUTOMATION ORCHESTRATION SCRIPT                                        #
# PROJECTS: LOCAL1 AIR-GAPPED CYBER RANGE CONTAINER DEPLOYMENT                  #
# AUTHOR: HANSOLO-MOHD FIROZ                                                    #
# PURPOSE: ONE-SHOT LAB INITIALIZATION AND SECURITY SEEDING                     #
#################################################################################

set -e # Exit immediately if any command fails

echo -e "\e[1;34m[*] Tearing down legacy infrastructure states...\e[0m"
podman compose down --timeout 0

echo -e "\e[1;34m[*] Booting local 4-node simulated cloud infrastructure...\e[0m"
podman compose up -d

echo -e "\e[1;33m[*] Awaiting mail subsystem initialization (Breaking Security Timer)...\e[0m"
# Poll the container logs until the entrypoint script is active and ready to accept changes
until podman logs local1_mail 2>&1 | grep -q "You need at least one mail account"; do
    echo -n "."
    sleep 2
done
echo ""

echo -e "\e[1;32m[+] Mail subsystem detected! Injecting persistent administrative target account...\e[0m"
# Inject user account. If it already exists on the volume, the image script handles it gracefully.
podman exec -it local1_mail setup email add admin@local1.local password123

echo -e "\e[1;32m[+] Infrastructure successfully verified and operational!\e[0m"
echo -e "\e[1;36m----------------------------------------------------------------------\e[0m"
# Display active local listening sockets across your designated ports
ss -tulpn | grep -E '8080|3306|10025|10587'
echo -e "\e[1;36m----------------------------------------------------------------------\e[0m"
