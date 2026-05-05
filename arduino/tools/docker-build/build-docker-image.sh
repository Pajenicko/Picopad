#!/bin/bash

docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t platformiobuild:latest -f Dockerfile .