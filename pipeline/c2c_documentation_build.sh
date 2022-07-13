#!/bin/bash
# run like this :::: ./c2c_documentation_build.sh
#we need to run this script from C2CPlatform dir
# -----------------------------------------Set Env Variables-----------------------------------------------------------------------

application_name="C2C Platform"
sitepath=/tmp/c2cwiki_site

# -------------------------------------------------------------------------------------------------------------------------

echo "Build started for $application_name"

# cd C2CPlatform
#mkdoc build command
python3.8 -m mkdocs build --clean --site-dir $sitepath -v
#delete sitemap.xml.gz from site folder
rm -rf $sitepath/sitemap.xml.gz
echo "Build Completed for $application_name"
