# elasticsearch-tf

Terraform module for elasticsearch on kubernetes on rook-ceph storage.
This likey isn't a direct copy-paste for you because of kubernetes implementation nuances from cluster to cluster, but core concepts can be transferred.

## usage

External modules can be brought into your project using `git submodule`:

```
cd some-config-repo/modules/
git submodule add https://github.com/nihr43/elasticsearch-tf.git
```

Then, this module can be used in a DRY manner for multiple environments:

```
module "elasticsearch-prod" {
  source = "./modules/elasticsearch-tf"
  context = "prod"
  ip = "10.0.100.101"
  image = "docker.elastic.co/elasticsearch/elasticsearch:8.6.1"
  storage = "8Gi"
  memory = "4"
}

module "elasticsearch-staging" {
  source = "./modules/elasticsearch-tf"
  context = "staging"
  ip = "10.0.100.100"
  image = "docker.elastic.co/elasticsearch/elasticsearch:8.6.1"
  storage = "4Gi"
  memory = "1"
}
```
