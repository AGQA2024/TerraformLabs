terraform {
    required_providers{
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }
}

provider "docker" {}

resource "docker_image" "web" {
  name = "httpd:latest"
}

resource "docker_container" "web" {
  name = "webserver"
  image = docker_container.web.image_id

  ports {
    internal = 80 
    external = 8080
  }
}