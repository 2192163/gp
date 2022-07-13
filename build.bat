@ECHO OFF
cls
cd .
set sitepath="C:\temp\c2cwiki_site"
echo "Site will be published to %sitepath%"

if not exist %sitepath% mkdir %sitepath%

python -m mkdocs build --clean --strict --no-directory-urls --site-dir %sitepath% -v

set /p DUMMY=Hit ENTER to continue...
start "" "%sitepath%\Index.html"