@echo off


if not "%~1"=="require" (call :logger ERROR "Expected 'require'"& exit /b 1)
if "%~2"=="" (call :logger ERROR "No library name given"& exit /b 1)
set lib_name=%~2

@rem Change directory to script directory
@rem https://java2blog.com/batch-get-script-directory/#Using_PUSHD_Command
pushd "%~dp0"

if not exist libs mkdir libs

@rem Get the config for the library
if not exist configs/%lib_name%.bat (call :logger ERROR "Could not find %lib_name%.bat in: %CD%\configs"& exit /b 1)
call configs/%lib_name%

if "%base_archive_name%"=="" (call :logger ERROR "No 'base_archive_name' was set by the config"& exit /b 1)

@rem Download library if it doesn't exist yet
cd libs
if not exist %base_archive_name% call :download_library
if %ERRORLEVEL% neq 0 (exit /b 1)
cd ..

@rem Setup builtch variables

call :get_script_dir
set library_dir_path=%script_dir%\libs\%base_archive_name%
set additional_include_dir=%library_dir_path%\%include_dir%
set additional_library_dir=%library_dir_path%\%library_dir%
set common_args=%common_args% -I "%additional_include_dir%" -L "%additional_library_dir%" %linker_flags%

@rem Go back to project directory and exit
popd
exit /b 0
@rem ----------------------------------------------------------------


@rem ----------------------- Download Library -----------------------
@rem The arguments are passed in using variables.
@rem Expects to be in the libs folder
:download_library

call :logger INFO "Downloading %lib_name% ..." 

if "%archive_extension%"=="" set archive_extension=zip

call :try_download "%base_download_url%" "%base_archive_name%" "%archive_extension%" || (exit /b 1)

call :over_logger SUCCESS "Downloaded %lib_name%"
call :logger INFO "Unpacking %lib_name% ..."

call tar -xf %file_base_name%.%file_extension% || (call :logger ERROR "Could not unpack %lib_name%"& del %file_base_name%.%file_extension%& exit /b 1)
del %file_base_name%.%file_extension%

call :over_logger SUCCESS "Unpacked %lib_name%"

exit /b 0
@rem ----------------------------------------------------------------


@rem --------------------- Get Script Directory ---------------------
@rem Gets the script directory and puts it into the script_dir variable (no backslash at the end)
@rem https://java2blog.com/batch-get-script-directory/#Using_PUSHD_Command
:get_script_dir
pushd "%~dp0"
set script_dir=%CD%
popd
exit /b
@rem ----------------------------------------------------------------


@rem ------------------------- Try Download -------------------------
@rem This accepts: base_url file_base_name file_extension
@rem Example: call :try_download https://myurl.com/something myfile txt
@rem This will be concatenated to: https://myurl.com/something/myfile.txt
:try_download

set base_url=%~1
set file_base_name=%~2
set file_extension=%~3

if "%base_url%"=="" (call :logger ERROR "No base url given"& exit /b 1)
if "%file_base_name%"=="" (call :logger ERROR "No file base name given (should be without the extension)"& exit /b 1)
if "%file_extension%"=="" (call :logger ERROR "No file extension given"& exit /b 1)

@rem https://stackoverflow.com/questions/6359820/how-to-set-commands-output-as-a-variable-in-a-batch-file
for /F %%i in ('curl.exe -o /dev/null --silent -w "%%{http_code}" -L "%base_url%/%file_base_name%.%file_extension%"') do set response_code=%%i

if not "%response_code%"=="200" (call :logger ERROR "Could not find file: '%base_url%/%file_base_name%.%file_extension%'"& exit /b 1)

for /F %%i in ('curl.exe --silent -OL -w "%%{http_code}" "%base_url%/%file_base_name%.%file_extension%"') do set response_code=%%i
if not "%response_code%"=="200" (
    call :logger ERROR "Could not download file: '%base_url%/%file_base_name%.%file_extension%'"& echo Response code: %response_code% & del %file_base_name%.%file_extension% & exit /b 1
)

exit /b 0
@rem ----------------------------------------------------------------


@rem --------------------------- Loggers ----------------------------
@rem Colors: https://www.codeproject.com/Questions/5250523/How-to-change-color-of-a-specific-line-in-batch-sc
:logger
set logger_prepend=
goto :internal_logger

@rem This one overwrites the previous line
:over_logger
set logger_prepend=[1F[0J
goto :internal_logger

:internal_logger
set color=[90m
set type=%~1
if "%type%"=="DEBUG" (
    if "%show_debug%"=="false" exit /b
)
if "%type%"=="ERROR" set color=[91m
if "%type%"=="INFO" set color=[94m
if "%type%"=="SUCCESS" set color=[92m
if "%type%"=="WARNING" set color=[93m
echo %logger_prepend%%color%[%type%][0m %~2
exit /b
@rem ----------------------------------------------------------------


@rem --------------------------- LICENSE ----------------------------
@rem MIT License

@rem Copyright (c) 2023 JulianBohne

@rem Permission is hereby granted, free of charge, to any person obtaining a copy
@rem of this software and associated documentation files (the "Software"), to deal
@rem in the Software without restriction, including without limitation the rights
@rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
@rem copies of the Software, and to permit persons to whom the Software is
@rem furnished to do so, subject to the following conditions:

@rem The above copyright notice and this permission notice shall be included in all
@rem copies or substantial portions of the Software.

@rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
@rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
@rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
@rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
@rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
@rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
@rem SOFTWARE.