#!/bin/bash
# run like this :::: ./c2c_documentation_publish.sh 11 0.11
version_title=$1
version_number=$2

if [[ $version_title = "" || $version_number = "" ]]
then
  echo "please pass the version and release number"
  exit 1
fi
# -----------------------------------------Set Env Variables-----------------------------------------------------------------------

version_number=$version_number
version_title=$version_title
version_alias="latest"
branch_name="gh-pages"
application_name="C2C Platform"
documentation_url=https://legendary-train-b67a52df.pages.github.io/
sitepath=/tmp/c2cwiki_site

# -------------------------------------------------------------------------------------------------------------------------

echo "Copy the files to  $version_number and $version_alias"

if [ -d $version_number ]
then
  rm -rf ./$version_number/*
  cp -r $sitepath/* ./$version_number/
else
  mkdir $version_number
  rm -rf ./$version_alias/*
  cp -r $sitepath/* ./$version_number/
  cp -r $sitepath/* ./$version_alias/
  cat versions.json | sed 's/\"latest\"//g' | jq . | jq --arg version_number "$version_number" --arg version_title "$version_title" --arg version_alias "$version_alias" '. |= [{"version": $version_number,"title": $version_title,"aliases": [$version_alias]}] + .'> versions_tmp.json
  rm -rf versions.json
  mv versions_tmp.json versions.json
fi


#rm -rf $sitepath

# rm -rf documentation

