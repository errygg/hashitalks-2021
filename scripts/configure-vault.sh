#!/bin/sh

OUTPUT=/tmp/vault-output.txt
export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_SKIP_VERIFY=true

vault operator init -n 1 -t 1 > ${OUTPUT?}

unseal=$(cat ${OUTPUT?} | grep "Unseal Key 1:" | sed -e "s/Unseal Key 1: //g")
root=$(cat ${OUTPUT?} | grep "Initial Root Token:" | sed -e "s/Initial Root Token: //g")

vault operator unseal ${unseal?}

vault login -no-print ${root?}

if [ "$1" = "namespace" ]
then
  vault namespace create ns1

  export VAULT_NAMESPACE=ns1
fi

vault secrets enable -version=2 kv

vault kv put kv/application name="Suzy Smith" email="ssmith@example.com"

vault secrets enable database

vault write database/config/mysql \
    plugin_name=mysql-database-plugin \
    allowed_roles="db-spring" \
    connection_url="{{username}}:{{password}}@tcp(localhost:3306)/" \
    username="vault" \
    password="vault"

vault write database/roles/db-spring \
    db_name=mysql \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON mydb.* TO '{{name}}'@'%';" \
    default_ttl="1m" \
    max_ttl="10m"

vault policy write app app-policy.hcl
