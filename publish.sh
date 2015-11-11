#!/usr/bin/env bash
BUCKET=expoundite.net
DIR=_site/
aws s3 sync $DIR s3://$BUCKET/ --content-type "text/html" --exclude "*.js" --exclude "*.css" --exclude "*.jpg" --exclude "*.png" --exclude "*.ico"
aws s3 sync $DIR s3://$BUCKET/ --include "*.js" --include "*.css" --include "*.jpg" --include "*.png" --include "*.ico" --exclude "[A-Za-z0-9-]*$"
