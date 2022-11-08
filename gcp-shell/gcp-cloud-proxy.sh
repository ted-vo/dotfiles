#!/bin/sh
# Auhtor: Ted Vo - 2022/11/08
# Shell hellper connect sql cloud via proxy

OS_ARCH=$(uname | tr '[:upper:]' '[:lower:]')
BIN_PATH=/usr/local/bin
CLOUD_SQL_PROXY=$BIN_PATH/cloud_sql_proxy

global_help() {
  echo "Shell script for run SQL Auth proxy client" 
  echo ""
  echo "Usage:"
  echo "gcp-cloud-proxy [flag] => flag for fast connect mode"
  echo "gcp-cloud-proxy        => without flag for sellection mode"
  echo " "
  echo "Available Commands:"
  echo ""
  echo "Flags:"
  echo "  -h, --help                show brief help"
  echo "  -c, --connection-name     projectID:region:instanceID"
  exit 0
}

install_cloud_sql_proxy_client() {
  echo ""
  echo " Downloading Cloud SQL Auth proxy client..."
  if [[ $OS_ARCH == "darwin" ]]; then
    curl -o $CLOUD_SQL_PROXY https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
  elif [[ $OS_ARCH == "linux" ]]; then
    wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O $CLOUD_SQL_PROXY
  fi

  echo " Grant execute permission"
  chmod +x $CLOUD_SQL_PROXY

  echo " Done"
  echo ""
}

require_shell() {
  if ! cloud_sql_proxy -version &> /dev/null; then
  echo "\"cloud_sql_proxy\" cloud not be found."
  while true; do
    read -p "Do you wish to install this program? (Yy or Nn): " yn
    case $yn in
      [Yy]* ) install_cloud_sql_proxy_client; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac
  done
 fi
}

connect_database() {
  require_shell

  echo ""
  echo "-----------------------------------------------------------"
  echo " Running with `cloud_sql_proxy -version`"
  echo " Host: localhost"
  echo " Port: 3306"
  echo "-----------------------------------------------------------"
  cloud_sql_proxy -instances=$1=tcp:3306 "-ip_address_types=PRIVATE"
}

selection_mode() {
  echo ""
  echo "-----------------------------------------------------------"
  echo " Current GCP Project-Id: $(gcloud config get-value project &> /dev/null)"
  echo "-----------------------------------------------------------"
  echo " List SQL Instances"
  gcloud sql instances list
  echo "-----------------------------------------------------------"

  read -p "Enter instance connection name (projectID:region:instanceID): " CONNECTION_NAME
  connect_database $CONNECTION_NAME
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      global_help ;;
    -c|--connection-name)
      shift
      CONNECTION_NAME=$1
      shift
      ;;
    *)
      echo ""
      echo "Run 'gcp-cloud-proxy -h|--help' for usage."
      exit 1
      break
      ;;
  esac
done

if [[ ! -z $CONNECTION_NAME ]]; then
  connect_database $CONNECTION_NAME
else
  selection_mode
fi
