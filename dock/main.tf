terraform {
    required_providers{
        docker = {
            source = "kreuzwerker/docker"
            version = "3.0.2"
        }
    }
}

// We're not saying how to get/make the image
// we're saying what we want the endpoint to look like
provider "docker" {}

resource "docker_image" "web" {
  name = "httpd:latest"
#   name = "nginx:latest"
}

resource "docker_container" "web" {
  name = "webserver"
#   image = docker_container.web.image_id // Was this the original?
  image = docker_image.web.image_id

  ports {
    internal = 80 // Forwarding traffic on?
    external = 8080 //Docker listening on 8080
  }
}