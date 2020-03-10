@Echo off
color f
cls
set ExtHDD=
echo Type in the drive letter of external USB HDD: (A:/B:/.../Y:/Z:)
set /P ExtHDD=

set CDKits=
for /F "delims=" %%D IN ('dir /aD /s /b %ExtHDD%\??????-??? ') do set "CDKits=%%~dpD" 
echo CDKits=[%CDKits%]

pushd "%CDKits%"
for /F "delims=" %%K IN ('dir /aD /b ??????-??? ') do (
	call :ReFolderStructure %%K
	if errorlevel 1 echo Failed to re-folder-structure for %%K, please check %CDKits%\%%K & goto RESULTFAILED
)
popd
goto RESULTPASSED



:RESULTFAILED
color 47
echo Result=FAIL
pause
goto END

:RESULTPASSED
color 27
echo Result=PASS
pause
start /b explorer "%CDKits%Output"
goto END

:SCRIPTPANIC
color 47
echo Script panic, please argue to Tony
pause
goto END




:ReFolderStructure
echo Checking kit folder: %1
pushd %1
for /F "tokens=1 delims=^(^)" %%I IN ('dir /a-D /b *.iso') do (
	echo Creating folder: "%CDKits%Output\%%I"
	if not exist "%CDKits%Output\%%I" mkdir "%CDKits%\Output\%%I"
	Echo Move "(%%I)_*.*" to "%CDKits%Output\%%I\"
	move /y "(%%I)_*.*" "%CDKits%Output\%%I\"
	if errorlevel 1 Echo Failed to move files & exit /b 1
)

dir /a-D /s /b *.* >NUL 2>&1
if errorlevel 1 (
	popd
	echo Folder %1 is empty, delete the folder %CDKits%%1
	rd /s /q "%CDKits%%1"
	if exist "%CDKits%%1" echo Failed to delete folder %CDKits%%1 & exit /b 1
) else (
	echo Folder %1 is not empty, keep folder %CDKits%%1
	popd
)
echo.
echo.
exit /b 0




:END
