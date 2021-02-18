# hashitalks-2021

This is the project that I used for HashiTalks 2021 on Spring Cloud and Vault.

This project includes a demo on how to consume Vault Dynamic MySQL
database credentials in a Spring App using annotations. The deployment uses
Waypoint to deploy to Docker for Mac as well as Docker for Mac Kubernetes.

## Demo Steps

1. Start Vault, MySQL, Waypoint, and Kubernetes

```sh
cd ./scripts/vault/
./start-vault.sh
cd ../mysql/
./start-mysql.sh
cd ../waypoint/
./start-waypoint.sh
cd ../
```

2. Configure Vault

```sh
cd ./vault/
./configure-vault.sh
cd ../../
```

### Vault Token Authentication with Docker

3. Get the root token from the output file

```sh
cat /tmp/vault-output.txt | grep "Root Token"
```

Copy the root token to the `spring.cloud.vault.token` value in
`./src/main/resources/bootstrap.yml` file.

4. Initialize Waypoint

```sh
waypoint init
```

5. Run the build/deploy

```sh
waypoint up
```

Open the deployment URL and view the page.

### Vault Kubernetes Authentication with Kubernetes

6. Reconfigure `bootstrap.yml` to use Kubernetes authentication

```yaml
...
    # authentication: TOKEN
    # token: s.D6Zb5rPAYXcvuze6FR2I0GZL

    authentication: KUBERNETES
    kubernetes:
      role: app
      kubernetes-path: kubernetes
...
```

7. Reconfigure `waypoint.hcl` to deploy and release to Kubernetes

```hcl
...
  deploy {
    /*use "docker" {
      service_port = 8080
    }*/
    use "kubernetes" {
      service_port = 8080
      service_account = "vault-auth"
    }
  }

  release {
    use "kubernetes" {
      load_balancer = true
    }
  }
...
```

8. Run the build/deploy

```sh
waypoint up
```

Open the release URL (should be http://localhost) and view the page.

### Endpoints
There are a few endpoints you can use to see the credentials, database
data, and restart.

9. `/getdbcredentials`

Will output the dynamically generated database `user`. This demonstrates that
the dynamic user is generated using the Vault configurations in `bootstrap.yml`
in conjunction with the Autowired DataSource.

10. `/getdbdata`

Will output data entered into the database during the MySQL start above. This
demonstrates that the dynamically generated database credentials can be used to
successfully pull data from the database and map to a Spring Model.

11. `/restart`

Will restart the application and create a new dynamic database credential.

## Cleanup

12. Cleanup the deployment by running `cd ./scripts; ./cleanup.sh`
