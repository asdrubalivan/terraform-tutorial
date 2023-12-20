# Terraform Flask Deployment Tutorial

## Introduction

This tutorial guides you through deploying a Flask application with PostgreSQL using Terraform and Docker. Terraform is an open-source infrastructure as code software tool that enables you to safely and predictably create, change, and improve infrastructure.

## Prerequisites

- Basic understanding of Python, Flask, and SQLAlchemy.
- Docker installed on your system.
- Terraform installed on your system.

## Project Structure

- `app.py`: Flask application.
- `Dockerfile`: Docker configuration for the Flask app.
- `main.tf`: Terraform configuration for the deployment.

## Step 1: Initialize Your Terraform Project

1. Open your terminal.
2. Navigate to your project directory.
3. Run the following command to initialize Terraform:

    ```bash
    terraform init
    ```

This command initializes Terraform, installs the Docker provider, and prepares your project for further actions.

## Step 2: Plan Your Infrastructure

Terraform uses the `terraform plan` command to create an execution plan. This command lets you preview the changes that Terraform will make to your infrastructure:

1. In your terminal, run:

    ```bash
    terraform plan
    ```

2. Review the output to understand what resources Terraform will create or modify.

## Step 3: Apply Your Configuration

After planning, apply the configuration to create the infrastructure:

1. Execute the following command:

    ```bash
    terraform apply
    ```

2. Confirm the action by typing `yes` when prompted.

Terraform will now create the Docker network, build the Flask app Docker image, and deploy the PostgreSQL container as specified in your `main.tf` file.

## Step 4: Accessing Your Flask Application

1. Once Terraform successfully applies the configuration, your Flask application will be running inside a Docker container.
2. Access the application at `http://localhost:5000` or the IP address of your Docker host.

## Step 5: Destroy Your Infrastructure

When you no longer need the infrastructure, you can destroy it:

1. Run:

    ```bash
    terraform destroy
    ```

2. Confirm the action by typing `yes` when prompted.

This command will remove all the resources managed by Terraform, effectively stopping and removing the Docker containers.

Certainly! Let's break down the `main.tf` file from your project, explaining each part in detail.

### Terraform Configuration Breakdown (`main.tf`)

The `main.tf` file is the core of your Terraform configuration, defining the infrastructure that Terraform will manage. Here's an explanation of its contents:

#### 1. Terraform Block and Provider Configuration

```hcl
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
```

- **Terraform Block**: This section specifies the Docker provider and its version. Terraform uses providers to interact with different services like AWS, Azure, or, in your case, Docker.
- **Provider "docker"**: This declares the use of the Docker provider. The configuration options within this block would be specific to Docker, like specifying a host if not using the default local setup.

#### 2. Docker Network Resource

```hcl
resource "docker_network" "app_network" {
  name = "app-network"
}
```

- **Resource "docker_network"**: Defines a Docker network resource named `app-network`. This network will be used to connect your Docker containers.

#### 3. Docker Image for Flask App

```hcl
resource "docker_image" "flask_app_image" {
  name         = "flask_app"
  build {
    context    = "${path.module}/Dockerfile"
  }
}
```

- **Resource "docker_image"**: This resource builds a Docker image for your Flask app. The `name` is set to `flask_app`, and the `build` context points to your `Dockerfile`, indicating where Docker should look to build the image.

#### 4. Docker Container for Flask App

```hcl
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
```

- **Resource "docker_container" for Flask**: Defines a Docker container for your Flask application. It references the image built in the previous step and maps the container's internal port 5000 to an external port 5000. The container is also attached to the previously defined network.

#### 5. Docker Image for PostgreSQL

```hcl
resource "docker_image" "postgres_image" {
  name = "postgres:latest"
}
```

- **Resource "docker_image" for PostgreSQL**: Pulls the latest PostgreSQL image from Docker Hub.

#### 6. Docker Container for PostgreSQL

```hcl
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
```

- **Resource "docker_container" for PostgreSQL**: Creates a Docker container for PostgreSQL. It uses the PostgreSQL image pulled earlier and sets environment variables for the database name, user, and password. This container is also part of the `app-network`.

### Summary

This `main.tf` file creates a Docker network, builds and runs a Docker container for the Flask application, and sets up a PostgreSQL database, all orchestrated by Terraform. The resources are interconnected, demonstrating how Terraform manages and provisions interdependent infrastructure components in a declarative way.

## Conclusion

Congratulations! You've successfully used Terraform to deploy a Flask application with PostgreSQL using Docker. This tutorial covered the basics of Terraform's workflow including initialization, planning, applying, and destroying infrastructure.

## Additional Resources

- For more detailed information on Terraform, visit [HashiCorp's Terraform Tutorials](https://developer.hashicorp.com/terraform/tutorials).
- To dive deeper into Terraform basics, check out [An Introduction to Terraform for Beginners](https://geekflare.com/terraform-tutorial/).
- For advanced Terraform concepts and techniques, refer to [GravityDevOps' Guide on Terraform](https://gravitydevops.com/terraform-step-by-step-guide/).
