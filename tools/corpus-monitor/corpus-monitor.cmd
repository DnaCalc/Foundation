@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0corpus-monitor.ps1" %*
