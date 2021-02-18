project = "hashitalks-2021"

app "app" {

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "errygg/app"
        tag = "latest"
      }
    }
  }

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
}
