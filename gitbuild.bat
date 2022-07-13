@ECHO OFF
cls
cd .

REM Set variables
REM -----------------------------------------Variables-----------------------------------------------------------------------
SET version_number=0.12
SET version_title="Sprint 12"
SET version_alias="latest"
SET branch_name="gh-pages"
SET application_name="C2C Platform"
SET documentation_url=https://legendary-train-b67a52df.pages.github.io/
SET sitepath="C:\temp\c2cwiki_site"
REM -------------------------------------------------------------------------------------------------------------------------


REM -------------------------------------------------------------------------------------------------------------------------
ECHO.
ECHO Build started for %application_name% and published to %documentation_url%"

call :ListVersions
call :BuidlAndPublish
set /p DUMMY=Git publish completed. Hit ENTER to continue...
call :RemoveCompiledFolder
Exit /B 0


:ListVersions
ECHO.
ECHO =========================
ECHO Currently hosted documentation versions
mike list
ECHO =========================
ECHO.

:BuildAndPublish
ECHO.
mike deploy --push -t %version_title% --update-aliases -b gh-pages %version_number% %version_alias%
REM python -m mkdocs gh-deploy --clean --no-directory-urls  -v
REM mike deploy --push -t %version_title% --update-aliases -b gh-pages %version_number% %version_alias%
REM mike set-default --push -b %branch_name% %version_alias%
ECHO Publish completed.
ECHO.

:RemoveCompiledFolder
RD /S /Q "./site"