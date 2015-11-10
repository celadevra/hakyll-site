#!/bin/bash

s3cmd sync _site/ s3://expoundite.net --config=.s3cfg --guess-mime-type --mime-type 'text/html' --recursive --acl-public --verbose
