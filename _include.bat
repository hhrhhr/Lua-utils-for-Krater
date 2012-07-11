@echo off

:: required variables
:: game directory
set krater=f:\steam\steamapps\common\krater
:: source language
set src_lang=eng
:: language number (not all known)
set src_lang_num=0
:: target language
set tr_lang=rus

:: path to tools
set qbms=tools\quickbms.exe
set lua=tools\lua.exe
set unluac=tools\unluac.jar
set luadec=tools\luadec.exe
:: comment this if Java in the PATH
set java=C:\Program Files (x86)\Java\jre7\bin\java.exe

:: do not edit!!! work directories
set db=_db_unp
set lng=_lang
set work=_work
set script=_script

:: values for quickbms's unpack
set lngdir=(0d972bab10b40fd3)_localization_
set luadir=(a14e8dfa2cd117e2)_script_

