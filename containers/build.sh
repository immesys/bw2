#!/bin/bash
pushd full
cp ../../bw2 .
docker build --no-cache -t immesys/bw2-dev .
docker push immesys/bw2-dev
popd
