data "digitalocean_images" "available" {
  filter {
    key    = "distribution"
    values = ["Ubuntu"]
  }
  filter {
    key    = "regions"
    values = ["fra1"]
  }
  filter {
    key      = "name"
    values   = ["LTS"]
    match_by = "substring"
  }
  filter {
    key    = "type"
    values = ["base"]
  }
  sort {
    key       = "created"
    direction = "desc"
  }
}

resource "digitalocean_droplet" "ubuntu" {
  image  = data.digitalocean_images.available.images[0].slug
  name   = var.name
  region = var.region
  size   = var.size
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  tags = ["roadmapsh"]
}