@echo off
set PROJ=sdcc4banks
set GBDK=..\..\gbdk
set GBDKLIB=%GBDK%\lib\small\asxxxx
set OBJ=build

set CFLAGS=-mgbz80 --no-std-crt0 -I %GBDK%\include -I %GBDK%\include\asm -I src\include -c

set LFLAGS=-n -- -z -m -j -yt2 -yo4 -ya4 -k%GBDKLIB%\gbz80\ -lgbz80.lib -k%GBDKLIB%\gb\ -lgb.lib 
set LFILES=%GBDKLIB%\gb\crt0.o

set ASMFLAGS=-plosgff -I"libc"

echo Cleanup...

if exist %OBJ% rd /s/q %OBJ%
if exist %PROJ%.gb del %PROJ%.gb
if exist %PROJ%.sym del %PROJ%.sym
if exist %PROJ%.map del %PROJ%.map

if not exist %OBJ% mkdir %OBJ%

echo ASSEMBLING THE STUB...
sdasgb %ASMFLAGS% %OBJ%\MBC1_RAM_INIT.rel MBC1_RAM_INIT.s
set LFILES=%LFILES% %OBJ%\MBC1_RAM_INIT.rel

echo COMPILING WITH SDCC4...
sdcc %CFLAGS% %PROJ%.c -o %OBJ%\%PROJ%.rel

echo LINKING WITH GBDK...
%GBDK%\bin\link-gbz80 %LFLAGS% %PROJ%.gb %LFILES% %OBJ%\%PROJ%.rel 

echo DONE!
