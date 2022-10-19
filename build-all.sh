#!/bin/bash

module purge
source bout.en

sh build-dependencies.sh
sh build-bout.sh

