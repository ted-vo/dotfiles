#!/bin/bash
# author: ted-vo - 2022/11/30
# Shell helper for developer

# https://gist.github.com/vncsna/64825d5609c146e80de8b1fd623011ca
# set -e, -u, -o, -x pipefail
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
if [ $OS == "darwin" ]; then
  OS="osx"
fi
ARCH="$(uname -m | tr '[:upper:]' '[:lower:]')"

PROTOC_VERSION=3.20.3
PLUGIN_GEN_GRPC_JAVA_VERSION=1.47.0
PLUGIN_GEN_GRPC_WEB_VERSION=1.4.2

header() {
  echo ""
  echo "--------------------------------------------------------------------"
  echo " ⚙️  $1 "
  echo "--------------------------------------------------------------------"
}

footer() {
  echo " ✅ OK"
}

spin() {
  local i=0
  local sp='/-\|'
  local n=${#sp}
  sleep 0.1
  while true; do
    printf "\b%s" "${sp:i++%n:1}"
    sleep 0.2
  done
}

show_loading() {
  spin &
  SPIN_PID=$!
  # Kill the spinner on any signal, including our own exit.
  trap "kill -9 $SPIN_PID &> /dev/null" `seq 0 15`
}

hide_loading() {
  printf "\bDone \e[1;32m√\e[0m\n"
  kill -9 $SPIN_PID &> /dev/null
}

check_go_bin() {
  header "checking go"

  if ! which go &> /dev/null; then
    echo " ❌ Please install golang first inorder to install go protoc generator"
    exit 1
  fi

  footer
}

check_protoc() {
  header "checking protoc"

  if ! which protoc &> /dev/null; then
    printf " ❌ protoc not found. Installing... "
    show_loading

    PB_REL="https://github.com/protocolbuffers/protobuf/releases"
    PROTOC_ZIP_NAME="protoc-${PROTOC_VERSION}-${OS}-${ARCH}.zip"

    curl -LOs $PB_REL/download/v${PROTOC_VERSION}/$PROTOC_ZIP_NAME
    unzip -qo $PROTOC_ZIP_NAME bin/protoc -d /usr/local
    rm $PROTOC_ZIP_NAME

    hide_loading
  fi

  footer
}

check_protoc_gen_validate() {
  header "checking protoc-gen-validate"

  if ! which protoc-gen-validate &> /dev/null; then
    printf " ❓ protoc-gen-validate not found. Installing... "
    show_loading
    go install github.com/envoyproxy/protoc-gen-validate@latest
    hide_loading
  fi
 
  footer
}

check_protoc_gen_go() {
  header "checking protoc-gen-go"
  
  if ! which protoc-gen-go &> /dev/null ; then
    printf " ❓ protoc-gen-go not found. Installing... "
    show_loading
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
    hide_loading
  fi

    footer
}

check_protoc_gen_go_grpc() {
  header "checking protoc-gen-go-grpc"

  if ! which protoc-gen-go-grpc &> /dev/null; then
    printf " ❓ protoc-gen-go-grpc not found. Installing... "
    show_loading
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
    hide_loading
  fi

  footer
}

check_protoc_gen_grpc_gateway() {
  header "check protoc-gen-grpc-gateway"

  if ! which protoc-gen-grpc-gateway &> /dev/null ; then
    printf " ❓ protoc-gen-grpc-gateway not found. Installing... "
    show_loading
    go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
    hide_loading
  fi

  footer
}

check_protoc_gen_swagger() {
  header "checking protoc-gen-swagger"
  
  if ! which protoc-gen-swagger &> /dev/null; then
    printf " ❓ protoc-gen-swagger not found. Installing... "
    show_loading
    go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger@latest
    hide_loading
  fi

  footer
}

check_protoc_gen_grpc_java() {
  header "checking protoc-gen-grpc-java"

  if ! which protoc-gen-grpc-java &> /dev/null; then
    printf " ❓ protoc-gen-grpc-java not found. Installing... "
    show_loading
    
    PB_REL="https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java"
    GRPC_JAVA="protoc-gen-grpc-java-${PLUGIN_GEN_GRPC_JAVA_VERSION}-${OS}-${ARCH}.exe"
    PLUGIN_NAME=protoc-gen-grpc-java
    curl -LOs $PB_REL/${PLUGIN_GEN_GRPC_JAVA_VERSION}/$GRPC_JAVA \
      && mv $GRPC_JAVA /usr/local/bin/$PLUGIN_NAME \
      && chmod +x /usr/local/bin/$PLUGIN_NAME

    hide_loading
  fi

  footer
}

check_protoc_gen_grpc_web() {
  header "checking protoc-gen-grpc-web"
  
  if ! which protoc-gen-grpc-web &> /dev/null; then
    printf " ❓ protoc-gen-grpc-web not found. Installing... "
    show_loading

    PB_REL="https://github.com/grpc/grpc-web/releases"
    GRPC_WEB="protoc-gen-grpc-web-${PLUGIN_GEN_GRPC_WEB_VERSION}-$(uname -s | tr '[:upper:]' '[:lower:]')-${ARCH}"
    PLUGIN_NAME=protoc-gen-grpc-web
    curl -LOs $PB_REL/download/${PLUGIN_GEN_GRPC_WEB_VERSION}/${GRPC_WEB} \
      && mv $GRPC_WEB /usr/local/bin/$PLUGIN_NAME \
      && chmod +x /usr/local/bin/$PLUGIN_NAME

    hide_loading
  fi

  footer
}

main() {
  check_go_bin

  # protobuf
  check_protoc

  # validate
  check_protoc_gen_validate

  # grpc-gateway
  check_protoc_gen_grpc_gateway
  check_protoc_gen_swagger

  # go
  check_protoc_gen_go
  check_protoc_gen_go_grpc

  # grpc-java
  check_protoc_gen_grpc_java

  # grpc-web
  check_protoc_gen_grpc_web
}

main
