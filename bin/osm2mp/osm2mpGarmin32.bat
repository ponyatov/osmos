rem Script by igitov
echo %time%
rem osmconvert32.exe RU-BA.osm.pbf|osm2mp32.exe - --config cfg-garmin\garmin-ru.cfg --mapid 00012345 --mapname "12345" --defaultcountry RU --defaultregion "12345" --countrylist "iso-3166-1-a2-ru.txt" --disableuturns --nodetectdupes --nointerchange3d --shorelines --hugesea 100000 --textfilter PrepareCP1251 --mp-header TreSize=1024 --mp-header RgnLimit=512 > map.mp
osm2mp32.exe RU-KB.osm --config cfg-garmin\garmin-ru.cfg --mapid 00012345 --mapname "12345" --defaultcountry RU --defaultregion "12345" --countrylist "iso-3166-1-a2-ru.txt" --disableuturns --nodetectdupes --nointerchange3d --shorelines --hugesea 100000 --textfilter PrepareCP1251 --mp-header TreSize=1024 --mp-header RgnLimit=512 > map.mp
echo %time%
@echo off

rem perl.exe R:\765\mp-postprocess.pl map.mp
echo %time%
rem C:\Garmin\cGPSmapperPR\cgpsmapper.exe map.mp

pause
