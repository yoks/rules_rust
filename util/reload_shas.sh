#!/usr/bin/env bash

# Enumerates the list of expected downloadable files, loads the SHAs for each file, then
# dumps the result to stdout
#
# Typically, output should be piped to ../known_shas.bzl

TOOLS="$(cat ./reload_shas_TOOLS.txt)"
TARGETS="$(cat ./reload_shas_TARGETS.txt)"
VERSIONS="$(cat ./reload_shas_VERSIONS.txt)"
BETA_ISO_DATES="$(cat ./reload_shas_BETA_ISO_DATES.txt)"
NIGHTLY_ISO_DATES="$(cat ./reload_shas_NIGHTLY_ISO_DATES.txt)"

enumerate_keys() {
  for TOOL in $TOOLS
  do
    for TARGET in $TARGETS
    do

      for VERSION in $VERSIONS
      do
        echo "$TOOL-$VERSION-$TARGET.tar.gz"
      done

      for ISO_DATE in $BETA_ISO_DATES
      do
        echo "$ISO_DATE/$TOOL-beta-$TARGET.tar.gz"
      done

      for ISO_DATE in $NIGHTLY_ISO_DATES
      do
        echo "$ISO_DATE/$TOOL-nightly-$TARGET.tar.gz"
      done
    done
  done
}

all_keys=($(enumerate_keys))

echo ${all_keys[@]} \
  | parallel --trim lr -d ' ' --will-cite 'printf "%s %s\n", {}, $(curl https://static.rust-lang.org/dist/{}.sha256 | cut -f1 --delimiter=" ")' \
  | sed "s/,//g" \
  > /tmp/reload_shas_shalist.txt

echo "# This is a generated file -- see util/reload_shas.sh"
echo "FILE_KEY_TO_SHA = {"
cat /tmp/reload_shas_shalist.txt | sort | awk '{print "   \"" $1 "\": \"" $2 "\","}'
echo "}"
