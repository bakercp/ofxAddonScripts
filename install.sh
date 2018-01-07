#!/usr/bin/env bash


# Configure openFrameworks repo branch.
export OF_REPO_BRANCH="TEMP-CI"
export OF_REPO_USER="bakercp"


# Make it easier to read output from make.
export MAKEFLAGS=-s


function do_install {
    cd ~
    git clone --depth=1 --branch=${OF_REPO_BRANCH} https://github.com/${OF_REPO_USER}/openFrameworks
    cd openFrameworks
    scripts/ci/addons/install.sh
}


function do_script {
    scripts/ci/addons/build.sh
}



