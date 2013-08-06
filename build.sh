#!/bin/sh
echo "Building CoffeeScript Files"
find . -type f | grep coffee | xargs coffee -c

echo "Running Tests"
echo "None"

echo "Archiving"
cd ..
tar czf cibyl_build.tar.gz cibyl/*
ls -lah cibyl_build.tar.gz
