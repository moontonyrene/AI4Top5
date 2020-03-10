@Echo off
color f
cls
set ExtHDD=
echo Type in the drive letter of external USB HDD: (A:/B:/.../Y:/Z:)
set /P ExtHDD=

set "openFldrList=%temp%\ReFolderStructureOpenFldr.lst"
if exist "%openFldrList%" del /f /q "%openFldrList%"

for /F "delims=" %%P IN ('dir /aD-S-H /b %ExtHDD%\* ') do (
	echo Checking platform: [%%P]
	pushd "%ExtHDD%\%%P"
	if exist "tier*" (
		echo.
		echo.
		echo Processing platform: [%%P]
		call :ProcessTiersInPlatform
		if errorlevel 1 echo Failed to re-folder-structure for platform %%P & goto RESULTFAILED
		echo.
		echo.
	)
	call :CleanupFldrs
	popd
)
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
notepad "%openFldrList%"
for /F "delims=" %%D IN ('type "%openFldrList%"') do (
	start /b explorer "%%D\"
)
goto END

:SCRIPTPANIC
color 47
echo Script panic, please argue to Tony
pause
goto END


:ProcessTiersInPlatform
for /F "delims=" %%T IN ('dir /aD-S-H /b * ') do (
	echo Checking tier: [%%T]
	pushd "%%T"
	if exist "??????-???" (
		echo Processing tier: [%%T]
		call :ProcessKitsInTier
		if errorlevel 1 echo Failed to re-folder-structure for tier %CD%\%%T & exit /b 1
	)
	popd
)
exit /b 0

:ProcessKitsInTier
set "delFldrList=%temp%\ReFolderStructureDelFldr.lst"
set "kitsFldrList=%temp%\ReFolderStructureKitsFldr.lst"
if exist "%delFldrList%"  del /f /q "%delFldrList%"
if exist "%kitsFldrList%" del /f /q "%kitsFldrList%"

set "outputFolder=%CD%\output"
set "emptyFolders=%CD%\emptyFolders"
echo outputFolder=[%outputFolder%]
echo emptyFolders=[%emptyFolders%]
echo %outputFolder%>>"%openFldrList%"

dir /aD-S-H /b /s * > "%kitsFldrList%"
type "%kitsFldrList%"
for /F "delims=" %%K IN (%kitsFldrList%) do (
	pushd "%%K"
	if exist "*.iso" (
		echo Processing folder: [%%K]
		call :ProcessFiles
		if errorlevel 1 echo Failed to re-folder-structure for kit %CD%\%%K & exit /b 1
	) else (
		echo Skip folder: [%%K]
	)
	popd
)
exit /b 0



:ProcessFiles
for /F "tokens=1 delims=^(^)" %%I IN ('dir /a-D /b *.iso') do (
	echo Creating folder: "%outputFolder%\%%I"
	if not exist          "%outputFolder%\%%I" mkdir "%outputFolder%\%%I"
	
	Echo move /y "(%%I)*.*" "%outputFolder%\%%I\"
	     move /y "(%%I)*.*" "%outputFolder%\%%I\"
	if errorlevel 1 Echo Failed to move files & exit /b 1
)
echo.
echo.
exit /b 0


:CleanupFldrs
for /f "delims=" %%D in ('dir /s /b /ad-S-H ^| sort /r') do (
	if exist "%%D" (
		dir /s /b /a-D-S-H "%%D\*.*" > NUL 2>&1
		if errorlevel 1 (
			echo Delete empty folder "%%D"
			rd /s /q "%%D"
		)
	)
)
exit /b 0



:END
color f
