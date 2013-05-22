REM Compile
call compile.bat

REM Copy supporting files
xcopy /Y /I public\* _public\public
xcopy /Y web.config _public\
xcopy /Y package.json _public\

REM Run
node _public/app.js