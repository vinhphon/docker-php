variable "TAG" {
  default = "8.2"
}
group "default" {
  targets = [
    "cli",
    "fpm"
    ]
}

target "cross" {
  dockerfile = "Dockerfile"
  platforms = [
    "linux/arm64",
    "linux/amd64"
  ]
}
target "cli" {
  context = "./cli"
  inherits = ["cross"]
  tags = ["docker.io/vinhphon/php:${TAG}-cli"]
}
target "fpm" {
  context = "./fpm"
  inherits = ["cross"]
  tags = ["docker.io/vinhphon/php:${TAG}-fpm"]
}
