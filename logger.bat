@rem This is just a simple logger that can be used by configs

@rem --------------------------- Loggers ----------------------------
@rem Colors: https://www.codeproject.com/Questions/5250523/How-to-change-color-of-a-specific-line-in-batch-sc
set color=[90m
set type=%~1
if "%type%"=="DEBUG" (
    if "%show_debug%"=="false" exit /b 0
)
if "%type%"=="ERROR" set color=[91m
if "%type%"=="INFO" set color=[94m
if "%type%"=="SUCCESS" set color=[92m
if "%type%"=="WARNING" set color=[93m
echo %color%[%type%][0m %~2
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