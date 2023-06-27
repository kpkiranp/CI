#!/bin/bash

sed "s/tag-version/$1/g" deployment.yaml > manifests/hello-world-app-manifest.yaml