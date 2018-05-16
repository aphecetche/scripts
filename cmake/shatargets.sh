#!/bin/sh

cd $1 && find bin -type f -exec shasum -a 256 {} \; && find lib -type f -exec shasum -a 256 {} \;
