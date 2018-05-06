#!/bin/bash


mkdir -p docs
cd docs

APIPIE_RECORD=params rails test:controllers
APIPIE_RECORD=examples rake test:controllers

bundle exec rake apipie:static OUT=docs
