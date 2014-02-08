#!/bin/bash
./site build
aws s3 sync _site/ s3://haoyangwrit.es --acl public-read
