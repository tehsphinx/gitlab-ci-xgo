
# XGO for Gitlab-CI

This is a docker container intended for the use with gitlab ci. [xgo](https://github.com/karalabe/xgo) 
is a [go](https://golang.org/) library making cross compilation with even with cgo very easy.
(For supported target platforms see the [github xgo](https://github.com/karalabe/xgo) page.)

Note: This container uses golang version 1.8

## Setup

Since xgo itself uses docker to compile to the different platforms we need to make docker
daemon available inside this container. 

Also xgo itself will map the volume `/go`. We need to map `/go/src` of this container to the parent
machine, so xgos container can get our source files. (More elegant solutions welcome!)

To do this we add two additional volumes to `config.toml` of the gitlab-ci runner we want to use:

```toml
# before (example)
volumes = ["/cache"]
# after
volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/go/src:/go/src", "/cache"]
```

Note: Be aware that `/go/src` is permanent with this solution. Parallel builds will interfere 
with each other and folders/files created in /go/src need to be cleaned up in the gitlab-ci
script.

## Usage

```yaml
image: tehsphinx/gitlab-ci-xgo:latest

variables:
  REPO_NAME: github.com/yourname/yourrepo

stages:
  - build

build_step:
  stage: build
  allow_failure: false
  script:
    # remove old copy of source files and replace with current version
    - rm -Rf $GOPATH/src/$REPO_NAME
    - mkdir -p $GOPATH/src/$REPO_NAME
    - mv $CI_PROJECT_DIR/* $GOPATH/src/$REPO_NAME
    
    # using repository as target directory for binaries
    - cd $GOPATH/src/$REPO_NAME

    # build for all target systems using xgo
    - xgo .    
    # build only for windows/386
    - xgo --targets=windows/386 .
```

For more build options with xgo see [https://github.com/karalabe/xgo](https://github.com/karalabe/xgo).
