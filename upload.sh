#!/bin/bash
git checkout master # only this branch gets published, allowing drafts
git stash save -u "Clean state for publishing" # move things under carpet
./site build
s3cmd sync _site/ s3://expoundite.net --guess-mime-type --mime-type 'text/html' --recursive --delete-removed --public-acl
git stash pop # release dirties from under the carpet
