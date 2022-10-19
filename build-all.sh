#!/bin/bash

module purge
source bout.en

sh build-bout.sh
sh build-dependencies.sh
