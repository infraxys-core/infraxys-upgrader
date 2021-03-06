echo "infraxys_mode: $infraxys_mode"
if [ "$infraxys_mode" == "DEVELOPER" ]; then
    log "Updating stack.yml: Nginx now listens on port 80 internally instead of port 443.";
    sed -i'' -e "s/{LOCAL_PORT}:443/{LOCAL_PORT}:80/g" /opt/infraxys/bin/stack.yml;

    if [ "$WINDOWS_MODE" == "true" ]; then
        log "Copying files to Infraxys bin directory.";
        cp 21/* /opt/infraxys/bin/;
    fi;
fi;
