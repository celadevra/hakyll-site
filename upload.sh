#!/bin/bash
git checkout master # only this branch gets published, allowing drafts
./site build
s3cmd sync _site/ s3://expoundite.net --guess-mime-type --mime-type 'text/html' --recursive --delete-removed --acl-public
