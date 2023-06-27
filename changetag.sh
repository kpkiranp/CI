#!/bin/bash

sed "s/tag-version/$1/g" deployment.yaml > manifest/hello-world-app-manifest.yaml