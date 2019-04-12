workflow "Build and Publish to Docker" {
  resolves = [
    "Require the master branch",
    "Build the container",
    "Publish the container"
  ]
  on = "push"
}

action "Require the master branch" {
  uses = "actions/bin/filter@4227a6636cb419f91a0d1afb1216ecfab99e433a"
  args = "branch master"
}

action "Login to Docker" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
  needs = ["Require the master branch"]
}

action "Build the container" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t mattrdash/jenkins-for-janky:lts ."
  needs = ["Login to Docker"]
}

action "Publish the container" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "push mattrdash/jenkins-for-janky:lts"
  needs = ["Build the container"]
}
