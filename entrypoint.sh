#!/usr/bin/env bash

set -eo pipefail;

function backup_and_prepare() {
  local backup_filename="infraxys-full-backup-$(date +%Y%m%d%H%M%S).tgz";
  log "Stopping and clearing the Infraxyd Docker containers.";
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
  #tar -czf backups/$backup_filename --exclude='backups' *;
  cd - > /dev/null;
  . ./env.sh;
  docker-compose -f stack.yml up -d db;
  sleep 30

}

function upgrade_database() {
  local required_db_version="$1";
  local first_upgrade="$2";
  local mysql_command="mysql -h db -u infraxys -pinfraxys infraxys";

  cd /
  if [ "$first_upgrade" != "true" ]; then
    log "Retrieving the current DB version from the database.";
    current_db_version="$($mysql_command -N -e 'select max(VERSION) from db_version_history;')";
  fi;

  if [ -z "$current_db_version" -o "$current_db_version" == "NULL" ]; then
      current_db_version="1";
  fi;

  if [ "$current_db_version" -eq "$required_db_version" ]; then
    log "Database is already at version $required_db_version.";
    return;
  elif [ "$current_db_version" -gt "$required_db_version" ]; then
    log "Database is in a higher version ($current_db_version) then the requested one ($required_db_version). Aborting.";
    return;
  fi;

  log "Upgrading from Infraxys DB version $current_db_version to $required_db_version.";

  cd sql;
  for f in $(ls -1 *\.sql | sort -n -k1); do
    f="$(basename "$f")" # remove ./
    log "Processing file $f";

    file_version="${f#"upgrade_"}";
    file_version="${file_version%".sql"}";
    if [ "$file_version" -gt "$current_db_version" ]; then
      if [ "$file_version" -gt "$required_db_version" ]; then
        log "Stopping upgrade since we're already at the required version $required_db_version.";
        break;
      else
        if [ -n "$dry_run" ]; then
          log "Would execute SQL script $f.";
        else
          log "Executing SQL script $f.";
          $mysql_command < $f;
          log "Setting version in database to $file_version.";
          $mysql_command -N -e "insert into db_version_history (version) values ($file_version)";
        fi;
        current_db_version="$file_version";
      fi;
    fi;
  done;
  cd -;
}

function perform_upgrade() {
  local required_db_version="$1";
  local required_sh_version="$2";
  local first_upgrade="false";

  backup_and_prepare;
  if [ ! -f "$versions_file" ]; then
    first_upgrade="true";
    write_versions "$required_db_version";
  fi;
  . "$versions_file";

  upgrade_database "$required_db_version" "$first_upgrade";


  if [ "$infraxys_mode" == "DEVELOPER" ]; then
    cd /opt/infraxys/bin;
  else
    cd /opt/infraxys/docker/infraxys;
  fi;
  log "Starting Infraxys";
  ./up.sh;
}

function write_versions() {
  echo -e "SH=$1" > "$versions_file";
}

function log() {
  local log_message="$1";
  local datepart=$(date +"%d-%m-%Y %H:%M:%S,%4N");
  echo "[$datepart]$dry_run $log_message";
}

function usage() {
  cat << EOF
  Usage: <Docker run command> required_db_version required_other_version db_hostname db_user db_password db_name infraxys_mode [DRY_RUN=true]

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
versions_file="$config_dir/VERSIONS";
required_db_version="$1";
required_other_version="$2";
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

perform_upgrade "$@";
