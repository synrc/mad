@echo off
Setlocal EnableDelayedExpansion
FOR /F "delims==" %%I IN ('git rev-parse HEAD ^| head -c 6') DO (
    < nul set /p str="-define(VERSION, "%%I%")." > include/mad.hrl
)
@echo on
escript.exe mad cle dep com bun mad
pause