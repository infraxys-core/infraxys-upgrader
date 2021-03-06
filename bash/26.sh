echo "infraxys_mode: $infraxys_mode"
if [ "$infraxys_mode" == "DEVELOPER" ]; then
    if [ "$WINDOWS_MODE" == "true" ]; then
        log "Overwriting stack.yml";
        cp 26/* /opt/infraxys/bin/;
    else
        log "Making sure cache is writable";
        set +e;
        sed -i'' 's/- ${LOCAL_DIR}\/cache:\/opt\/infraxys\/cache:ro/- ${LOCAL_DIR}\/cache:\/opt\/infraxys\/cache:rw/g' /opt/infraxys/bin/stack.yml;
        set -e;
        log "Result: ";
        cat /opt/infraxys/bin/stack.yml | grep cache;
    fi;
fi;
