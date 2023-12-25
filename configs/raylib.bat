
@rem ----------------------- Download Source ------------------------
set version=%~1
if "%version%"=="" set version=4.5.0
call logger INFO "Raylib version: %version%"

@rem ---------- https://github.com/raysan5/raylib/releases ----------
set base_download_url=https://github.com/raysan5/raylib/releases/download/%version%
set base_archive_name=raylib-%version%_win64_mingw-w64
@rem https://github.com/raysan5/raylib/releases/download/4.2.0/raylib-4.2.0_win64_mingw-w64.zip
@rem This is optional if the archive extension is zip
set archive_extension=zip

@rem --------------------- Compiler Information ---------------------
set include_dir=include
set library_dir=lib
set linker_flags=-lraylib -lopengl32 -lgdi32 -lwinmm

@rem -------------------------- Meta Data ---------------------------
set description=Raylib is a multi-media library for games and graphics
