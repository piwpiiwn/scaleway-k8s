terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  backend "s3" {
    bucket         = "piwpiiwn-tfstate"
    dynamodb_table = "terraform-lock"
    key            = "scaleway-k8s.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    profile        = "piwpiiwn"
  }

  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
}
