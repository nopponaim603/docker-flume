#!/bin/bash

FLUME_CONF_DIR="/opt/flume/conf"
FLUME_AGENT_NAME="docker"

[[ -d "${FLUME_CONF_DIR}"  ]]  || { echo "Flume config file not mounted in /opt/flume-config";  exit 1; }
[[ -z "${FLUME_AGENT_NAME}" ]] && { echo "FLUME_AGENT_NAME required"; exit 1; }

echo "Starting flume agent : ${FLUME_AGENT_NAME}"

flume-ng agent \
  -n ${FLUME_AGENT_NAME} \
  -c ${FLUME_CONF_DIR} \
  -f ${FLUME_CONF_DIR}/flume.conf \
  -Dflume.root.logger=DEBUG,console \

