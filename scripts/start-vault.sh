#!/bin/sh

vault server -config vault.hcl > /tmp/vault.log 2>&1 &
