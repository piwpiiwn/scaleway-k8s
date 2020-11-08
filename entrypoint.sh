#!/bin/sh

set -e

Main(){
  PrintLogo
  desired_state="$1" && { shift || true; }
  case $desired_state in
    up) ClusterUp $@
      ;;
    stop) ClusterStop $@
      ;;
    down) ClusterDown $@
      ;;
    show-kubeconfig) ShowKubeconfig
      ;;
    *) PrintUsage && exit 1
      ;;
  esac
}

PrintLogo(){
  cat <<EOF

========================================
  PiwPiiwn - k8s Cluster State Manager
========================================

EOF
}

PrintUsage(){
  cat <<EOF
Usage: $0 [up|stop|down|show-kubeconfig]
---
up              - Create the cluster
stop            - Stop destroy workers
down            - Destroy cluster
show-kubeconfig - Displays kubeconfig file

EOF
}

TerraformInit(){
  # https://github.com/hashicorp/terraform/issues/13022#issuecomment-294262392
  terraform init \
    -backend-config "bucket=${AWS_TFBACKEND_S3_BUCKET:-piwpiiwn-tfstate}" \
    -backend-config "key=scaleway-k8s-${CLUSTER_NAME:-piwpiiwn}.tfstate"
}

ClusterUp(){
  TerraformInit
  terraform apply ${@:---var-file=/app/cluster-start.tfvars --auto-approve}
}

ClusterStop(){
  TerraformInit
  terraform apply ${@:---var-file=/app/cluster-stop.tfvars --auto-approve}
}

ClusterDown(){
  TerraformInit
  terraform destroy ${@:---var-file=/app/cluster-start.tfvars --auto-approve}
}

ShowKubeconfig(){
  TerraformInit
  echo '=== KUBECONFIG ==='
  terraform output kubeconfig
  echo '=================='
}

Setup(){
  # Create scaleway config file from environment vars
  [ -f ~/.config/scw/config.yaml ] && { return; } || { mkdir -p ~/.config/scw; }

  cat > ~/.config/scw/config.yaml <<EOF
access_key: ${SCW_ACCESS_KEY:-VARNOTSET}
secret_key: ${SCW_SECRET_KEY:-VARNOTSET}
default_organization_id: ${SCW_DEFAULT_ORGANIZATION_ID:-VARNOTSET}
default_project_id: ${SCW_DEFAULT_PROJECT_ID:-VARNOTSET}
default_region: ${SCW_DEFAULT_REGION:-VARNOTSET}
default_zone: ${SCW_DEFAULT_ZONE:-VARNOTSET}
EOF
  sed -i '/.*VARNOTSET$/d' ~/.config/scw/config.yaml

  # Update tfvars based on env vars
  awk '/^variable /{gsub("\"","");print $2}' 99_vars.tf \
  | while read var_name
  do
    local env_var_name=$( echo "$var_name" | awk '{print toupper($0)}')
    local value="$(eval echo "\$${env_var_name}")"
    if [ ! -z "$value" ]
    then
      for file in $(ls /app/*.tfvars)
      do
        grep -q '^'${var_name}'\s*=' $file \
          && sed -i 's/^'${var_name}'\s*=.*/'${var_name}' = "'${value}'"/' $file \
          || echo "${var_name} = \"${value}\"" >> $file
      done
    fi
  done
}


# Setup if I am inside docker container
awk -F/ '$2 == "docker"' /proc/self/cgroup > /dev/null 2>&1 && Setup

Main $@
