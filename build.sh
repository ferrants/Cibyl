#!/bin/sh
echo "Building CoffeeScript Files"
ln -s ../../bower_components/bootstrap/dist/ public/lib/bootstrap
find . -type f | grep -v bower | grep coffee | xargs coffee -c

echo "Running Tests"
echo "None"

echo "Archiving"
cd ..
tar czf cibyl_build.tar.gz cibyl/*
ls -lah cibyl_build.tar.gz
