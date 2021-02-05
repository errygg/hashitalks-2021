# Spring Cloud Vault Example

This project includes a demo on how to consume Vault KVs and Dynamic MySQL
database credentials in a Spring App using annotations.

## Demo Steps

1. Start Vault and MySQL

```sh
cd ./scripts
./start-vault.sh
./start-mysql.sh
cd ../
```

2. Configure Vault

```sh
./configure-vault.sh
```

3. Get the root token from the output file

```sh
cat /tmp/vault-output.txt | grep "Root Token"
```

Copy the root token to the `spring.cloud.vault.token` file in
`./src/main/resources/bootstrap.properties` file.

> This repo will be updated soon to use other authentication methods

4. Run the build

```sh
./gradlew bootRun
```

### Endpoints
There are a few endpoints you can use to see the KV, credentials, and database
data.

5. `/getdbcredentials`

Will output the dynamically generated database `user`. This demonstrates that
the dynamic user is generated using the Vault configurations in `bootstrap.yml`
in conjunction with the Autowired DataSource.

6. `/getkvdata`

Will output the KV data entered during the vault configuration step above. This
demonstrates how to use Value bean annotations to map data in the Vault KV.

7. `/getdbdata`

Will output data entered into the database during the MySQL start above. This
demonstrates that the dynamically generated database credentials can be used to
successfully pull data from the database and map to a Spring Model.

## Cleanup

8. Cleanup the Vault deployment by running `./scripts/cleanup.sh`
