#!/bin/bash

# ENV CONF_API_PORT=4444
# ENV CONF_TRADING_MODE=paper
# ENV CONF_IB_USER=greg2017
# ENV CONF_IB_PASS=alglab111
# ENV CONF_IB_READ_ONLY=no

docker rm -f algolab

docker run -id  -e CONF_VNC_PASS=changeme \
                -e CONF_CONTROLLER_PORT=4440 \
                -e CONF_API_PORT=4100 \
                -e CONF_TRADING_MODE=paper \
                -e CONF_IB_USER=alglab333 \
                -e CONF_IB_PASS=greg2017 \
                -e CONF_IB_READ_ONLY=no \
                -e CONF_IB_GATEWAY=alglab333:4100 \
                -p 5901:5901 \
                --name algolab \
                 gcr.io/virtualmachines-154415/docker-centos-desktop-algolab:1.0.0-4
