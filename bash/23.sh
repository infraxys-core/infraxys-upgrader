if [ "$infraxys_mode" == "DEVELOPER" ]; then
    if [ "$WINDOWS_MODE" == "true" ]; then
        cat >> /opt/infraxys/config/variables <<EOF
set GLOBAL_ZONE_LIMIT_KEY=binary_remote_addr
set GLOBAL_ZONE_MEMORY=10m
set GLOBAL_ZONE_RATE=100r
set ACTION_ZONE_LIMIT_KEY=binary_remote_addr
set ACTION_ZONE_MEMORY=10m
set ACTION_ZONE_RATE=100r
set ACTION_ZONE_LIMIT_BURST=100
set ACTION_ZONE_LIMIT_DELAY=50
EOF
    else
        cat >> /opt/infraxys/config/variables <<EOF
export GLOBAL_ZONE_LIMIT_KEY=binary_remote_addr
export GLOBAL_ZONE_MEMORY=10m
export GLOBAL_ZONE_RATE=100r
export ACTION_ZONE_LIMIT_KEY=binary_remote_addr
export ACTION_ZONE_MEMORY=10m
export ACTION_ZONE_RATE=100r
export ACTION_ZONE_LIMIT_BURST=100
export ACTION_ZONE_LIMIT_DELAY=50
EOF
    fi;
else
    log "Setting FluentD Docker image version to 3.0.0 in config/variables.";
    echo "3.0.0" > /opt/infraxys/config/vars/FLUENTD_VERSION;
    echo "binary_remote_addr" > /opt/infraxys/config/vars/GLOBAL_ZONE_LIMIT_KEY;
    echo "10m" > /opt/infraxys/config/vars/GLOBAL_ZONE_MEMORY;
    echo "100r" > /opt/infraxys/config/vars/GLOBAL_ZONE_RATE;
    echo "binary_remote_addr" > /opt/infraxys/config/vars/ACTION_ZONE_LIMIT_KEY;
    echo "10m" > /opt/infraxys/config/vars/ACTION_ZONE_MEMORY;
    echo "100r" > /opt/infraxys/config/vars/ACTION_ZONE_RATE;
    echo "100" > /opt/infraxys/config/vars/ACTION_ZONE_LIMIT_BURST;
    echo "50" > /opt/infraxys/config/vars/ACTION_ZONE_LIMIT_DELAY;
fi;


