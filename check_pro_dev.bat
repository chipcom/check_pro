c:\Harbour\bin\hbmk2 check_pro.hbp -b -comp=mingw

@REM @echo off
@REM if %1. == . goto MissingParameter
@REM if %1. == develop. goto GoodParameter
@REM if %1. == debug.   goto GoodParameter
@REM rem if %1. == release. goto GoodParameter

@REM echo ����室��� 㪠���� ��ࠬ��� "debug" ��� "develop"
@REM rem echo ����室��� 㪠���� ��ࠬ��� "debug" ��� "release" ��� "develop"
@REM goto End

@REM :GoodParameter

@REM rem echo ���訩 ��ࠬ���

@REM if %1 == debug (
@REM rem    hbmk2 ..\HelloHarbour.hbp -b   
@REM     echo Debug parameter
@REM ) else (
@REM   rem echo Develop parameter
@REM   c:\Harbour\bin\hbmk2 chip_mo_f003.hbp
@REM   echo %errorlevel%
@REM 	if %ErrorLevel% equ 0 (goto SuccessCompiled) else (goto ErrorCompiled)
@REM )
@REM :ErrorCompiled
@REM echo �訡�� �������樨
@REM goto End
@REM :SuccessCompiled
@REM echo
@REM echo ************************************
@REM echo �ᯥ譠� �������樨
@REM copy chip_mo.exe d:\_mo\chip\exe
@REM echo ************************************
@REM echo
@REM goto End
@REM :MissingParameter
@REM echo ������ ��ࠬ���
@REM :End