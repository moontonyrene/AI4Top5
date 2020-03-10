@echo off
cls

if exist "x:\Fajita6U1.0_RS1" rd /s /q "x:\Fajita6U1.0_RS1"
if exist "x:\Pita1.0_RS1"     rd /s /q "x:\Pita1.0_RS1"
if exist "x:\Saffron1.1"      rd /s /q "x:\Saffron1.1"
if exist "x:\18C2 SyrahDG"    rd /s /q "x:\18C2 SyrahDG"
xcopy /icherky "%~dp0Test\*.*"    x:\
xcopy /icherky "%~dp0TestV3\*.*"  x:\
pause
cls


mkdir x:\Platform_DEL\Tier_DEL\KITPN_DEL\BID_DEL\SN_DEL
mkdir x:\Platform_KEP\Tier_DEL\KITPN_DEL\BID_DEL\SN_DEL
mkdir x:\Platform_KEP\Tier_KEP\KITPN_DEL\BID_DEL\SN_DEL
mkdir x:\Platform_KEP\Tier_KEP\KITPN_KEP\BID_DEL\SN_DEL
mkdir x:\Platform_KEP\Tier_KEP\KITPN_KEP\BID_KEP\SN_DEL
mkdir x:\Platform_KEP\Tier_KEP\KITPN_KEP\BID_KEP\SN_KEP
echo XX > x:\Platform_KEP\Tier_KEP\KITPN_KEP\BID_KEP\SN_KEP\KEEP.FLG
