#!/bin/bash
pushd full
cp ../../bw2 .
docker build -t immesys/bw2 .
docker push immesys/bw2
popd
