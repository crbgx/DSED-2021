@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto bfa3106fb46e4d988bc7840eb5121532 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot FSMD_microphone_tb_func_synth xil_defaultlib.FSMD_microphone_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0