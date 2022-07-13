@ECHO OFF
cls
cd .

REM ---------------VARIABLES---------------
SET CURRENT_DIR=%~dp0
SET LOG_FILE="%CURRENT_DIR%/log_documentationsetup.log"
    ECHO ========================================================================== 
    ECHO ========================================================================== >> %LOG_FILE%
    ECHO %DATE% %TIME% Current directory=%CURRENT_DIR%
    ECHO %DATE% %TIME% Current directory=%CURRENT_DIR% >> %LOG_FILE%
    ECHO %DATE% %TIME% Log file path=%LOG_FILE% 
    ECHO %DATE% %TIME% Log file path=%LOG_FILE% >> %LOG_FILE%
    ECHO %DATE% %TIME% Local machine Setup for documentation is initialized
    ECHO %DATE% %TIME% Local machine Setup for documentation is initialized >> %LOG_FILE%
goto :PRE_REQUISITE

:PRE_REQUISITE
REM ---------------CHECKS---------------
    python -V | find /v "Python" >NUL 2>NUL && (goto :PYTHON_DOES_NOT_EXIST)
    ECHO %DATE% %TIME% Python Exists 
    ECHO %DATE% %TIME% Python Exists >> %LOG_FILE%

    pip -V | find /v "pip" >Nul 2>Nul && (goto :PIP_DOES_NOT_EXIST)
    ECHO %DATE% %TIME% Pip Exists
    ECHO %DATE% %TIME% Pip Exists >> %LOG_FILE%

    git --version | find /v "git" >Nul 2>Nul && (goto :GIT_DOES_NOT_EXIST)
    ECHO %DATE% %TIME% GIT Exists 
    ECHO %DATE% %TIME% GIT Exists >> %LOG_FILE%
goto :SETUP_MKDOCS

:PYTHON_DOES_NOT_EXIST
    ECHO %DATE% %TIME% ERROR :::::: Python is not installed on your system. OR not setup in the PATH variable. 
    ECHO %DATE% %TIME% ERROR :::::: Python is not installed on your system. OR not setup in the PATH variable. >> %LOG_FILE%
    ECHO Now opeing the download URL.
    start "" "https://www.python.org/downloads/windows/"
goto :END


:PIP_DOES_NOT_EXIST
    ECHO %DATE% %TIME% ERROR :::::: Pip is not installed on your system OR not setup in the PATH variable. 
    ECHO %DATE% %TIME% ERROR :::::: Pip is not installed on your system OR not setup in the PATH variable. >> %LOG_FILE%
    ECHO Now opeing the download URL.
    start "" "https://pip.pypa.io/en/stable/"
goto :END

:GIT_DOES_NOT_EXIST
    ECHO %DATE% %TIME% ERROR :::::: GIT is not installed on your system OR not setup in the PATH variable. 
    ECHO %DATE% %TIME% ERROR :::::: GIT is not installed on your system OR not setup in the PATH variable. >> %LOG_FILE%
    ECHO Now opeing the download URL.
    start "" "https://git-scm.com/downloads"
goto :END

:SETUP_MKDOCS
    REM ---------------MKDOCS---------------
    pip install mkdocs==1.2.3 >> %LOG_FILE%
    ECHO %DATE% %TIME% MKDOCS installed. 
    ECHO %DATE% %TIME% MKDOCS installed. >> %LOG_FILE%

    REM ---------------MKDOCS-MATERIAL---------------
    pip install mkdocs-material==7.3.3 >> %LOG_FILE%
    ECHO %DATE% %TIME% MKDOCS material theme installed. 
    ECHO %DATE% %TIME% MKDOCS material theme installed. >> %LOG_FILE%

    REM ---------------MKDOCS-MATERIAL-PLUGINS---------------
    pip install markdown >> %LOG_FILE%
    ECHO %DATE% %TIME% Python Markdown plugin installed. 
    ECHO %DATE% %TIME% Python Markdown plugin installed. >> %LOG_FILE%

    pip install markdown-include >> %LOG_FILE%
    ECHO %DATE% %TIME% Python Markdown include plugin installed. 
    ECHO %DATE% %TIME% Python Markdown include plugin installed. >> %LOG_FILE%

    pip install mkdocs-git-revision-date-localized-plugin >> %LOG_FILE%
    ECHO %DATE% %TIME% mkdocs-git-revision-date-localized-plugin plugin installed. 
    ECHO %DATE% %TIME% mkdocs-git-revision-date-localized-plugin plugin installed. >> %LOG_FILE%

    pip install mike==1.0.1 >> %LOG_FILE%
    ECHO %DATE% %TIME% Mike plugin installed. 
    ECHO %DATE% %TIME% Mike plugin installed. >> %LOG_FILE%

    pip install mkdocs-markdownextradata-plugin >> %LOG_FILE%
    ECHO %DATE% %TIME% mkdocs-markdownextradata-plugin plugin installed. 
    ECHO %DATE% %TIME% mkdocs-markdownextradata-plugin plugin installed. >> %LOG_FILE%

    pip install mkdocs-print-site-plugin >> %LOG_FILE%
    ECHO %DATE% %TIME% mkdocs-print-site-plugin plugin installed. 
    ECHO %DATE% %TIME% mkdocs-print-site-plugin plugin installed. >> %LOG_FILE%

    pip install mkdocs-table-reader-plugin >> %LOG_FILE%
    ECHO %DATE% %TIME% mkdocs-table-reader-plugin plugin installed. 
    ECHO %DATE% %TIME% mkdocs-table-reader-plugin plugin installed. >> %LOG_FILE%
goto :END

:END
    ECHO %DATE% %TIME% Local machine Setup for documentation is completed 
    ECHO %DATE% %TIME% Local machine Setup for documentation is completed >> %LOG_FILE%
    ECHO ========================================================================== 
    ECHO ========================================================================== >> %LOG_FILE%
goto :EOF