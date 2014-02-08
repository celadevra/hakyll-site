#!/bin/bash
./site build
s3cmd sync _site/ s3://haoyangwrit.es --guess-mime-type --mime-type 'text/html' --recursive --delete-removed --acl-public
