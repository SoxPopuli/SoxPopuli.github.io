#!/bin/env bash

npm install
mkdir dist

cp -rv public/404.html dist/

npx parcel build public/index.html