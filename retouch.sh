#!/bin/bash

# give the last commit time to generated html as modification time
for i in `find ./expoundite.net/ -name "*page" -type f | sed -e 's/^.\///'`; do
  MTIME=`git log -1 --pretty=format:%ai $i | awk '{print $1$2}' | sed -e 's/[-]//g' -e 's/[:]//' -e 's/:/\./'`;
  touch -m -t $MTIME ./$i
done
