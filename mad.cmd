@echo off
setlocal
set madscript=%~f0
escript.exe "%madscript:.cmd=%" %*
