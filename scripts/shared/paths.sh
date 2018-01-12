#!/usr/bin/env bash
set -e

if [ "$CI" = true ]; then
  OF_ROOT=${OF_ROOT:-~/openFrameworks}

  if [ "$APPVEYOR" = true ]; then
    THIS_ADDON_NAME=${APPVEYOR_PROJECT_SLUG#*/}
    THIS_USERNAME=${APPVEYOR_PROJECT_SLUG%/*}
    THIS_BRANCH=${APPVEYOR_REPO_BRANCH}
  elif [ "$TRAVIS" = true ]; then
    THIS_ADDON_NAME=${TRAVIS_REPO_SLUG#*/}
    THIS_USERNAME=${TRAVIS_REPO_SLUG%/*}
    THIS_BRANCH=${TRAVIS_BRANCH}
  fi
else
  OF_ROOT=${OF_ROOT:-$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../../.." && pwd )}

  THIS_ADDON_NAME=$(basename $( cd "$( dirname "${BASH_SOURCE[0]}" )/../.."  && pwd ))
  THIS_USERNAME=$(whoami)
  THIS_BRANCH=$(git rev-parse --abbrev-ref HEAD)
fi

# Helpful env variables.
DEFAULT_CLONE_DEPTH=1
MAKEFLAGS="-s"

# OF paths.
OF_ADDONS_PATH=${OF_ADDONS_PATH:-${OF_ROOT}/addons}
OF_SCRIPTS_PATH=${OF_SCRIPTS_PATH:-${OF_ROOT}/scripts}
OF_APOTHECARY_PATH=${OF_APOTHECARY_PATH:-${OF_SCRIPTS_PATH}/apothecary}

# Addon paths.
THIS_ADDON_PATH=${THIS_ADDON_PATH:-${OF_ADDONS_PATH}/${THIS_ADDON_NAME}}
THIS_ADDON_SHARED_PATH=${THIS_ADDON_SHARED_PATH:-${THIS_ADDON_PATH}/shared}
THIS_ADDON_SHARED_DATA_PATH=${THIS_ADDON_SHARED_DATA_PATH:-${THIS_ADDON_SHARED_PATH}/data}
THIS_ADDON_SCRIPTS_PATH=${THIS_ADDON_SCRIPTS_PATH:-${THIS_ADDON_PATH}/scripts}

# OF Clone info.
OF_CLONE_DEPTH=${OF_CLONE_DEPTH:-${DEFAULT_CLONE_DEPTH}}
OF_CLONE_BRANCH=${OF_CLONE_BRANCH:-${THIS_BRANCH}}
OF_CLONE_USERNAME=${OF_CLONE_USERNAME:-openFrameworks}

# Addon Clone info.
ADDON_CLONE_DEPTH=${ADDON_CLONE_DEPTH:-${DEFAULT_CLONE_DEPTH}}
ADDON_CLONE_BRANCH=${ADDON_CLONE_BRANCH:-${THIS_BRANCH}}
ADDON_CLONE_USERNAME=${ADDON_CLONE_USERNAME:-${THIS_USERNAME}}

if [ "$DEBUG" = true ]; then
  echo "================================================================================"
  echo "                                 OF_ROOT: ${OF_ROOT}"
  echo "                          OF_ADDONS_PATH: ${OF_ADDONS_PATH}"
  echo "                         OF_SCRIPTS_PATH: ${OF_SCRIPTS_PATH}"
  echo "                      OF_APOTHECARY_PATH: ${OF_APOTHECARY_PATH}"
  echo ""
  echo "                         THIS_ADDON_NAME: ${THIS_ADDON_NAME}"
  echo "                         THIS_ADDON_PATH: ${THIS_ADDON_PATH}"
  echo "             THIS_ADDON_SHARED_DATA_PATH: ${THIS_ADDON_SHARED_DATA_PATH}"
  echo "                 THIS_ADDON_SCRIPTS_PATH: ${THIS_ADDON_SCRIPTS_PATH}"
  echo ""
  echo "                           THIS_USERNAME: ${THIS_USERNAME}"
  echo "                             THIS_BRANCH: ${THIS_BRANCH}"
  echo ""
  echo "                          OF_CLONE_DEPTH: ${OF_CLONE_DEPTH}"
  echo "                         OF_CLONE_BRANCH: ${OF_CLONE_BRANCH}"
  echo "                       OF_CLONE_USERNAME: ${OF_CLONE_USERNAME}"
  echo ""
  echo "                       ADDON_CLONE_DEPTH: ${ADDON_CLONE_DEPTH}"
  echo "                      ADDON_CLONE_BRANCH: ${ADDON_CLONE_BRANCH}"
  echo "                    ADDON_CLONE_USERNAME: ${ADDON_CLONE_USERNAME}"
  echo "================================================================================"
fi
