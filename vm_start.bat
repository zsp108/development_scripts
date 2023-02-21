@echo off

D:
cd D:\Program Files (x86)\VMware\VMware Workstation\
vmrun.exe -T ws start "E:\vm\mydb\mydb.vmx" nogui

pause
