#!/bin/sh

echo "Configuring Vault..."
OUTPUT=/tmp/vault-output.txt
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true

vault operator init -n 1 -t 1 > ${OUTPUT?}

unseal=$(cat ${OUTPUT?} | grep "Unseal Key 1:" | sed -e "s/Unseal Key 1: //g")
root=$(cat ${OUTPUT?} | grep "Initial Root Token:" | sed -e "s/Initial Root Token: //g")

vault operator unseal ${unseal?}

vault login -no-print ${root?}

vault secrets enable -version=2 kv

vault kv put kv/application name="Suzy Smith" email="ssmith@example.com"

# Configure MySql Database Secrets Engine
vault secrets enable database

vault write database/config/mysql \
    plugin_name="mysql-database-plugin" \
    allowed_roles="db-spring" \
    connection_url="{{username}}:{{password}}@tcp(localhost:3306)/" \
    username="vault" \
    password="vault"

vault write database/roles/db-spring \
    db_name="mysql" \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON mydb.* TO '{{name}}'@'%';" \
    default_ttl="1m" \
    max_ttl="10m"

vault policy write app app-policy.hcl

vault auth enable kubernetes

kubectl create serviceaccount vault-auth

kubectl apply --filename vault-auth-service-account.yml

VAULT_SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")
SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

vault write auth/kubernetes/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://kubernetes.docker.internal:6443" \
  kubernetes_ca_cert="$SA_CA_CRT"

vault write auth/kubernetes/role/app \
  bound_service_account_names="vault-auth" \
  bound_service_account_namespaces="default" \
  policies="app" \
  ttl="24h"
