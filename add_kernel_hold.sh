#!/usr/bin/env bash

kernel=$(uname -r)

echo "Hold kernel $kernel"
apt-mark hold $kernel
