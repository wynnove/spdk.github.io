#!/usr/bin/env bash

set -e

cd $(dirname $0)

repo=$(dirname $0)/spdk

git clone --depth 1 https://github.com/spdk/spdk $repo

doc_version=$(cd $repo; git rev-parse HEAD)

(cd $repo; git submodule update --init; ./configure)
# Overwrite header and footer with the spdk.io versions
cp _doc_header.html $repo/doc/header.html
cp _doc_footer.html $repo/doc/footer.html
cp _doc_stylesheet.css $repo/doc/stylesheet.css

(cd $repo/doc; make clean; make)
git rm -rf doc
cp -R $repo/doc/output/html doc
git add doc
rm -rf $repo

echo "$doc_version" > _doc_version.txt
git add _doc_version.txt

echo
echo "New docs generated"
echo
git status
