#!/bin/sh

./gen-tags.sh > tags

sed -i -e '/TAGS_BEGIN/,/TAGS_END/ {
  /TAGS_BEGIN/{
    n; r tags
  }
  /TAGS_END/!d
}' README.md

rm tags
