#!/usr/bin/env sh

PYTHON_EXECUTABLE=$( $(which python3) -c 'import sys; print(sys.executable)')

cmake ~/alice/tests/ROOT \
  -G Ninja \
  -DPYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}

