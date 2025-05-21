#!/bin/bash
cd /opt/gatling/gatling
echo "Running Gatling LoadGen..."
echo 1 | ./bin/gatling.sh -s BasicSimulation
