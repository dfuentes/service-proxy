#!/bin/bash

set -e
#set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

# Required vars
CONSUL_TEMPLATE=${CONSUL_TEMPLATE:-/usr/local/bin/consul-template}
CONSUL_CONFIG=${CONSUL_CONFIG:-/consul-template/config.d}
CONSUL_CONNECT=${CONSUL_CONNECT:-consul.service.consul:8500}
CONSUL_MINWAIT=${CONSUL_MINWAIT:-2s}
CONSUL_MAXWAIT=${CONSUL_MAXWAIT:-10s}
CONSUL_LOGLEVEL=${CONSUL_LOGLEVEL:-info}

function usage {
cat <<USAGE
  launch.sh             Start a consul-backed haproxy instance

Configure using the following environment variables:
  SERVICE_NAME          Name of the service to proxy to.
  SERVICE_ENV           Environment tag to proxy to.
Consul-template variables:
  CONSUL_TEMPLATE       Location of consul-template bin
                        (default /usr/local/bin/consul-template)
  CONSUL_CONNECT        The consul connection
                        (default consul.service.consul:8500)
  CONSUL_CONFIG         File/directory for consul-template config
                        (/consul-template/config.d)
  CONSUL_LOGLEVEL       Valid values are "debug", "info", "warn", and "err".
                        (default is "info")

USAGE
}

function launch_haproxy {
    if [ "$(ls -A /usr/local/share/ca-certificates)" ]; then
        cat /usr/local/share/ca-certificates/* >> /etc/ssl/certs/ca-certificates.crt
    fi

    vars=$@

    ${CONSUL_TEMPLATE} -config ${CONSUL_CONFIG} \
                       -log-level ${CONSUL_LOGLEVEL} \
                       -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                       -consul ${CONSUL_CONNECT} ${vars}
}

launch_haproxy $@
