# Stop all the processes
pkill vault nomad

# Remove the log files
rm -rf /tmp/vault-output.txt /tmp/vault.log /tmp/nomad.log

# Remove all the data dirs
rm -rf /tmp/vault /tmp/nomad

# Cleanup MySQL
mysql -u root < ./mysql/cleanup.sql
brew services stop mysql

# Uninstall Waypoint and remove snapshots
waypoint server uninstall -auto-approve -platform docker
rm -rf waypoint-server-snapshot* data.db waypoint-restore.db.lock

# Delete all K8s deployments
kubectl delete --all deployments
kubectl delete sa vault-auth