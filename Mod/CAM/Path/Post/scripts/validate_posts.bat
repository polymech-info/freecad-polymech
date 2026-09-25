@echo off
REM Script to validate FreeCAD Post Processor Scripts (Syntax Check)
REM Usage: validate_posts.bat [optional_filename]

set FC_PYTHON="C:\Program Files\FreeCAD 1.0\bin\python.exe"

IF NOT EXIST %FC_PYTHON% (
    echo Error: FreeCAD Python not found at %FC_PYTHON%
    pause
    exit /b 1
)

IF "%~1"=="" (
    echo Checking ALL python scripts in current directory...
    for %%f in (*.py) do (
        echo [Checking] %%f
        %FC_PYTHON% -m py_compile "%%f"
        if errorlevel 1 (
            echo [FAILED] %%f has syntax errors!
        ) else (
            echo [OK] %%f
        )
    )
) ELSE (
    echo [Checking] %~1
    %FC_PYTHON% -m py_compile "%~1"
    if errorlevel 1 (
        echo [FAILED] %~1 has syntax errors!
    ) else (
        echo [OK] %~1
    )
)

echo.
echo Validation complete.

