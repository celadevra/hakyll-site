#!/bin/bash

# give the last commit time to generated html as modification time
for i in `find . -name "*page" -type f`; do
  MTIME=`git log -1 --pretty=format:%ai $i | awk '{print $1$2}' | sed -e 's/[-:]//g'`;
  touch -m -t MTIME ./_site/`dirname $i`/`basename $i .page`
done