#!/usr/bin/env bash
DEFAULT="expoundite"
PROFILE=${AWS_PROFILE:-$DEFAULT}
BUCKET=expoundite.net
DIR=_site/
aws  s3  sync $DIR s3://$BUCKET/ --profile "$PROFILE"
