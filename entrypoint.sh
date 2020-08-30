#!/usr/bin/env bash

set -eo pipefail;

export do_upgrade="false";

function backup_and_prepare() {
    local backup_filename="infraxys-full-backup-$(date +%Y%m%d%H%M%S)-${current_release_number}.tgz";
    log "Stopping and clearing the Infraxys Docker containers.";
    export SILENT="true";
    if [ "$infraxys_mode" == "DEVELOPER" ]; then
        echo "Windows mode: $WINDOWS_MODE"
        if [ "$WINDOWS_MODE" == "true" ]; then
            docker stop infraxys-developer-tomcat;
            docker stop infraxys-developer-web;
            docker stop infraxys-developer-vault;
            docker stop infraxys-developer-db;
            #docker rm infraxys-developer-tomcat;
            #docker rm infraxys-developer-web;
            #docker rm infraxys-developer-vault;
            #docker rm infraxys-developer-db;
        else
            cd /opt/infraxys/bin;
            ./stop.sh;
            ./rm.sh;
        fi;
    else
        cd /opt/infraxys/docker/infraxys;
        ./stop.sh;
        docker-compose -f stack.yml rm -f;
    fi;
    cd /opt/infraxys > /dev/null;
    if [ "$WINDOWS_MODE" == "true" ]; then
        docker start infraxys-developer-db;
    else
        log "Creating backup file $infraxys_host_root/backups/$backup_filename.";
        mkdir -p backups;
        tar -czf backups/$backup_filename --exclude='backups' *;
        if [ "$infraxys_mode" == "DEVELOPER" ]; then
            cd /opt/infraxys/bin;
            . ./env.sh;
        else
            cd /opt/infraxys/docker/infraxys;
            . ../env;
        fi;
        log "Starting the database.";
        docker-compose -f stack.yml up -d db;
    fi;
    sleep 30;
}

function run_upgrade_scripts() {
    cd /bash;
    local tmp_release="$current_release_number";
    for f in $(ls -1 *\.sh | sort -n -k1); do
        f="$(basename "$f")" # remove ./
        log "Processing file $f";

        file_version="${f%".sh"}";
        if [ "$file_version" -gt "$tmp_release" ]; then
            if [ "$file_version" -gt "$to_release_number" ]; then
                log "Stopping script upgrade since we're already at the required version $to_release_number.";
                break;
            else
                if [ -n "$dry_run" ]; then
                    log "Would execute script $f.";
                else
                    log "Executing script $f.";
                    ./$f;
                fi;
                tmp_release="$file_version";
            fi;
        else
            log "Not processing this file since it's already applied."
        fi;
    done;
    cd - >/dev/null;
}

function upgrade_database() {
    cd /

    if [ "$current_release_number" -eq "$to_release_number" ]; then
        log "Infraxys is already at version $to_release_number.";
        return;
    elif [ "$current_release_number" -gt "$to_release_number" ]; then
        log "Infraxys is in a higher version ($current_release_number) then the requested one ($to_release_number). Aborting.";
        return;
    fi;

    do_upgrade="true";
    log "Upgrading from Infraxys DB version $current_release_number to $to_release_number.";
    cd sql;
    for f in $(ls -1 *\.sql | sort -n -k1); do
        f="$(basename "$f")" # remove ./
        log "Processing file $f";

        file_version="${f%".sql"}";
        if [ "$file_version" -gt "$current_release_number" ]; then
            if [ "$file_version" -gt "$to_release_number" ]; then
                log "Stopping database upgrade since we're already at the required version $to_release_number.";
                break;
            else
                if [ -n "$dry_run" ]; then
                    log "Would execute SQL script $f.";
                else
                    log "Executing SQL script $f.";
                    $mysql_command < $f;
                    log "Script $f finished."
                fi;
                current_release_number="$file_version";
            fi;
        else
            log "Not processing this file since it's already applied."
        fi;
    done;
    cd - >/dev/null;
}

function perform_upgrade() {
    backup_and_prepare;

    run_upgrade_scripts
    upgrade_database;

    log "Database upgrade complete.";
    if [ "$infraxys_mode" == "DEVELOPER" ]; then
        cd /opt/infraxys/bin;
    else
        cd /opt/infraxys/docker/infraxys;
    fi;
    if [ "$do_upgrade" == "true" ]; then
        if [ -n "$dry_run" ]; then
            log "Would update the version_history table.";
        else
            log "Adding version $to_release_number to the version_history table";
            $mysql_command -N -e "insert into version_history (release_number, infraxys_version) values ($to_release_number, '$to_infraxys_version');";
            if [ "$infraxys_mode" == "DEVELOPER" ]; then
                if [ "$WINDOWS_MODE" == "true" ]; then
                    log "Setting Tomcat Docker image version to $to_infraxys_version in env.bat.";
                    sed -i'' -e "s/set TOMCAT_VERSION=.*/set TOMCAT_VERSION=${to_infraxys_version}/g" /opt/infraxys/bin/env.bat;
                else
                    log "Setting Tomcat Docker image version to $to_infraxys_version in config/variables.";
                    sed -i'' -e "s/export TOMCAT_VERSION=.*/export TOMCAT_VERSION=${to_infraxys_version}/g" /opt/infraxys/config/variables;
                fi;
            else
                log "Updating version in config/vars/TOMCAT_VERSION."
                echo "$to_infraxys_version" > /opt/infraxys/config/vars/TOMCAT_VERSION;
            fi;
        fi;
    fi;

    if [ "$WINDOWS_MODE" == "true" ]; then
        echo
        echo "===================="
        echo "Please start Infraxys using up.bat";
        echo "===================="
    else
        log "Starting Infraxys";
        if [ "$infraxys_mode" == "DEVELOPER" ]; then
            . ./env.sh;
        else
            . ../env;
        fi;
        docker-compose -f stack.yml up -d;
    fi;
    log "Pulling latest provisioning server image";
    docker pull quay.io/jeroenmanders/infraxys-provisioning-server:ubuntu-full-18.04-latest;
}

function log() {
    local log_message="$1";
    local datepart=$(date +"%d-%m-%Y %H:%M:%S,%4N");
    echo "[$datepart]$dry_run $log_message";
}

function usage() {
    cat << EOF
    Usage: <Docker run command> to_release_number to_infraxys_version db_hostname db_user db_password db_name infraxys_mode [DRY_RUN=true]

         docker run --network infraxys-developer --rm -it \
          -v /opt/infraxys:/opt/infraxys:rw \
          --name infraxys-upgrader quay.io/jeroenmanders/infraxys-upgrader:latest \
          31 3 db infraxys <PASSWORD> infraxys DEVELOPER /opt/infraxys false;


        docker run --network infraxys-developer --rm -it \
          -v /opt/infraxys:/opt/infraxys:rw \
          --name infraxys-upgrader quay.io/jeroenmanders/infraxys-upgrader:latest \
          latest latest db infraxys <PASSWORD> infraxys SERVER /opt/infraxys false;
EOF
}

echo "Starting Infraxys upgrader";
if [ $# -ne 8 -a $# -ne 9 ]; then
    usage;
    exit 1;
fi;

to_release_number="$1";
to_infraxys_version="$2";
db_hostname="$3";
db_user="$4";
db_password="$5";
db_name="$6";
infraxys_mode="$7";
infraxys_host_root="$8";

if [ $# -eq 8 -o "$9" != "false" ]; then
    dry_run=" [DRY RUN]";
    log "Performing dry run because 7th argument is not 'false'.";
else
    dry_run="";
fi;

if [ "$infraxys_mode" != "DEVELOPER" -a "$infraxys_mode" != "SERVER" ]; then
    log "Infraxys mode '$infraxys_mode' is not supported.";
    exit 1;
fi;

mysql_command="mysql -h db -u infraxys -pinfraxys infraxys";
log "Retrieving the current DB version from the database.";
$mysql_command -N -e 'select * from version_history;'
export current_release_number="$($mysql_command -N -e 'select max(release_number) from version_history;')";
log "Current release: $current_release_number";
perform_upgrade "$@";
