terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13"
    }
  }
}
provider "docker" {
  # Configuration options
}

# Network for the containers
resource "docker_network" "app_network" {
  name = "app-network"
}

resource "docker_image" "flask_app_image" {
  name         = "flask_app"
  build {
    context    = "${path.module}/Dockerfile"
  }
}

resource "docker_container" "flask_app_container" {
  name    = "flask_app"
  image   = docker_image.flask_app_image.image_id
  ports {
    internal = 5000
    external = 5000
  }
  networks_advanced {
    name = docker_network.app_network.name
  }
}

# PostgreSQL image
resource "docker_image" "postgres_image" {
  name = "postgres:latest"
}

# PostgreSQL container
resource "docker_container" "postgres_container" {
  name  = "postgres"
  image = docker_image.postgres_image.image_id
  env = [
    "POSTGRES_DB=exampledb",
    "POSTGRES_USER=exampleuser",
    "POSTGRES_PASSWORD=examplepass"
  ]
  networks_advanced {
    name = docker_network.app_network.name
  }
}
