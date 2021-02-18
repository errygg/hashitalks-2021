#!/bin/sh

echo "Starting Vault server..."
vault server -config vault.hcl > /tmp/vault.log 2>&1 &
