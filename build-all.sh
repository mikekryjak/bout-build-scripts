#!/bin/bash

module purge
source bout.env

sh build-dependencies.sh
sh build-bout.sh

