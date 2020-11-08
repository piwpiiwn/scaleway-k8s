#!/bin/bash

BASEDIR=$(dirname $BASH_SOURCE | xargs realpath)

alias k8s-cluster-state-manager="docker run --rm -it --env-file=${BASEDIR}/.env k8s-cluster-state-manager"

complete -W 'up stop down show-kubeconfig' k8s-cluster-state-manager
