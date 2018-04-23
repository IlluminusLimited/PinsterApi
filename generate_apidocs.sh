#!/bin/bash

APIPIE_RECORD=params rake test:controllers
APIPIE_RECORD=examples rake test:controllers

bundle exec rake apipie:static OUT=doc
