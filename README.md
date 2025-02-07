Project url: https://roadmap.sh/projects/iac-digitalocean

# Goal
The goal of this project is to introduce you to the basics of IaC using Terraform.

# How to Deploy the Latest LTS Ubuntu Version on DigitalOcean using Terraform?

To deploy the latest LTS version of Ubuntu, we can leverage Terraform's Data Sources. The [digitalocean_images](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/images) data source retrieves information from DigitalOcean using API calls. By specifying the filters below, we can obtain the latest Ubuntu LTS image in the `fra1` region, ordered by creation date. Selecting the first result from the list ensures we get the most recent version.

```tf
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
```

Then, we use the *slug* attribute as the image input for the `digitalocean_droplet` resource.

```tf
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
```

This will deploy the actual server. Note that the Droplet will be exposed to the internet, and by default, it uses the root user. For enhanced security, it is recommended to create a non-root user and set up a firewall to restrict access. However, these steps are outside the scope of this project.


# Using remote state

If you want to store your Terraform state in a remote backend for free, you can use HCP Terraform. Here's how you can configure it:

Look at the cloud block and its configuration in the following example:
```tf
terraform {
  cloud {
    organization = "roadmap-sh"
    hostname     = "app.terraform.io"

    workspaces {
      name = "iac-digitalocean"
    }
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
```
To access HCP Terraform, you can use environment variables. Set the API token by running:
```sh
export TF_TOKEN_app_terraform_io="<token>"
```
You can obtain the token from the [Terraform Cloud settings](https://app.terraform.io/app/settings/tokens)

Additionally, you can use the following variable to run Terraform locally instead of using the HCP Terraform remote runner:

```sh
export TF_FORCE_LOCAL_BACKEND=1
```
Setting this variable allows the state to be **saved remotely** while executing Terraform locally. 