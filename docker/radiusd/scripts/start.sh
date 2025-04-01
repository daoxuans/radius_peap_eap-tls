#!/usr/bin/env sh

set -e
. "${SCRIPTDIR}/config.sh"

# Start FreeRadius
# Check if initialization is necessary
if [ ! -f "${INITFINISHED}" ]; then
    /usr/bin/printf "Initialization not performed. Running managecerts.sh...\n"
    ./managecerts.sh
else
    /usr/bin/printf "Initialization already performed. Skipping managecerts.sh.\n"
fi

cd /etc/raddb

if [ -z "$DEBUG" ]; then
    exec radiusd -f
else 
    exec radiusd -X
fi
