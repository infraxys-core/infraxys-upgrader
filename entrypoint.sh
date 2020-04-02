#!/usr/bin/env bash

set -eo pipefail;

export newer_version="false";

function backup_and_prepare() {
  local backup_filename="infraxys-full-backup-$(date +%Y%m%d%H%M%S).tgz";
  log "Stopping and clearing the Infraxys Docker containers.";
  export SILENT="true";
  if [ "$infraxys_mode" == "DEVELOPER" ]; then
    cd /opt/infraxys/bin;
    ./stop.sh;
    ./rm.sh;
  else
    cd /opt/infraxys/docker/infraxys;
    ./stop.sh;
    docker-compose -f stack.yml rm -f;
  fi;
  cd /opt/infraxys > /dev/null;
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
  sleep 30
}

function upgrade_database() {
  cd /
  if [ "$first_upgrade" != "true" ]; then
    log "Retrieving the current DB version from the database.";
    current_release_number="$($mysql_command -N -e 'select max(release_number) from version_history;')";
  fi;

  if [ -z "$current_release_number" -o "$current_release_number" == "NULL" ]; then
      current_release_number=1;
  fi;

  newer_version="true";

  if [ "$current_release_number" -eq "$to_release_number" ]; then
    log "Database is already at version $to_release_number.";
    return;
  elif [ "$current_release_number" -gt "$to_release_number" ]; then
    log "Database is in a higher version ($current_release_number) then the requested one ($to_release_number). Aborting.";
    return;
  fi;

  log "Upgrading from Infraxys DB version $current_release_number to $to_release_number.";

  cd sql;
  for f in $(ls -1 *\.sql | sort -n -k1); do
    f="$(basename "$f")" # remove ./
    log "Processing file $f";

    file_version="${f#"upgrade_"}";
    file_version="${file_version%".sql"}";
    if [ "$file_version" -gt "$current_release_number" ]; then
      if [ "$file_version" -gt "$to_release_number" ]; then
        log "Stopping upgrade since we're already at the required version $to_release_number.";
        break;
      else
        if [ -n "$dry_run" ]; then
          log "Would execute SQL script $f.";
        else
          log "Executing SQL script $f.";
          $mysql_command < $f;
        fi;
        current_release_number="$file_version";
      fi;
    fi;
  done;
  cd - >/dev/null;
}

function perform_upgrade() {
  local first_upgrade="false";

  backup_and_prepare;

  table_exists="$($mysql_command -N -e 'SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = "infraxys" AND table_name = "version_history";')";
  if [ "$table_exists" == "0" ]; then
    log "This database has not been upgraded yet.";
    first_upgrade="true";
  fi;

  upgrade_database;

  log "Database upgrade complete.";
  if [ "$infraxys_mode" == "DEVELOPER" ]; then
    cd /opt/infraxys/bin;
  else
    cd /opt/infraxys/docker/infraxys;
  fi;
  log "Newer version: $newer_version.";
  if [ "$newer_version" == "true" ]; then
    if [ -n "$dry_run" ]; then
      log "Would update the version_history table.";
    else
      log "Updating the version_history table";
      $mysql_command -N -e "insert into version_history (release_number, infraxys_version) values ($to_release_number, '$to_infraxys_version')";
      if [ "$infraxys_mode" == "DEVELOPER" ]; then
        log "Setting Tomcat Docker image version to $to_infraxys_version in config/variables.";
        sed -i'' -e "s/export TOMCAT_VERSION=.*/export TOMCAT_VERSION=${to_infraxys_version}/g" /opt/infraxys/config/variables;
      else
        log "Updating version in config/vars/TOMCAT_VERSION."
        echo "$to_infraxys_version" > /opt/infraxys/config/vars/TOMCAT_VERSION;
      fi;
    fi;
  fi;

  log "Starting Infraxys";
  if [ "$infraxys_mode" == "DEVELOPER" ]; then
    . ./env.sh;
  else
    . ../env;
  fi;
  docker-compose -f stack.yml up -d;
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

config_dir="/opt/infraxys/config";
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
perform_upgrade "$@";
