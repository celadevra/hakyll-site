#!/usr/bin/env bash
BUCKET=expoundite.net
DIR=_site/
aws s3 sync $DIR s3://$BUCKET/ --content-type "text/html"
