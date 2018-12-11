@echo off
Mode Con: Cols=100 Lines=40
title smb聊天
Chcp 936
color 0f
set path=%~dp0
Setlocal enabledelayedexpansion
IF /i "%1"=="win" goto win
if exist "%path%admin.uac" (set nick=管理员 & set admin=1) ELSE (set nick=用户)
if exist "%path%sti.bat" call sti.bat&goto income


:inf
cls
echo 请输入网络smb服务器：
set /p net=IP:
echo set net=%net%>>sti.bat
echo 请输入用户民：
set /p user=name:
echo set user=%user%>>sti.bat

:income
if exist "%net%\temp.txt" (
	echo %nick% %user% ^加^入^了^群^聊 >>%net%\temp.txt
) ELSE (
	goto unfile
)

:scream
if /I "%win%" == "1" (cls & goto scream_half)
cls
set mesg=uninput
echo ==================================================================
type %net%\temp.txt || goto :unfile
echo,
echo ==================================================================
:scream_half
echo 信息内容(输入指令或信息，按enter发送)：
set /p mesg=%user%:
if /I "%mesg%"=="uninput" goto scream
if /I "%mesg:~,1%"=="/" goto command
echo %nick%^<%user%^>^:%mesg% >>%net%\temp.txt
goto scream

:command
if /I "%admin%" == "1" (
	if /I "%mesg%"=="/cls" goto clear
	if /I "%mesg%"=="/del" goto del_history
)
if /I "%win%" == "1" (
	if /I "%mesg%"=="/reset" goto reset
	if /I "%mesg%"=="/logout" goto logout
	if /I "%mesg%"=="/exit" goto exit
	if /I "%mesg%"=="/host" goto host
	cls
	echo,
	echo                 无法使用的或未知的指令^!
	call:sleep 1
	goto scream
)
if /I "%admin%" == "1" (
	if /I "%mesg%"=="/history" goto history
)
if /I "%mesg%"=="/history" goto error_unadmin
if /I "%mesg%"=="/del" goto error_unadmin
if /I "%mesg%"=="/cls" goto error_unadmin  
if /I "%mesg%"=="/license" goto license
if /I "%mesg%"=="/reset" goto reset
if /I "%mesg%"=="/logout" goto logout
if /I "%mesg%"=="/help" goto help
if /I "%mesg%"=="/exit" goto exit
if /I "%mesg%"=="/host" goto host
if /I "%mesg%"=="/win" goto win_manager
cls
echo,
echo,
echo,
echo                           未知的指令^!
call:sleep 1
goto scream



:unfile
del /q %net%\temp.txt
echo %time% %date% >>%net%\temp.txt
echo %nick% %user% ^加^入^了^群^聊 >>%net%\temp.txt
goto scream

:clear
echo ==================================================================>>%net%\history.txt
type %net%\temp.txt>>%net%\history.txt
del /q %net%\temp.txt
echo %time% %date% >>%net%\temp.txt
echo %nick% %user% ^清^空^了^群^聊 >>%net%\temp.txt
goto scream

:reset
echo %nick% %user% ^退^出^了^群^聊 >>%net%\temp.txt
del /q %path%sti.bat
goto inf

:host
del /q %path%sti.bat
echo set user=%user%>>%path%sti.bat
echo %nick% %user% ^退^出^了^群^聊 >>%net%\temp.txt
cls
echo 请输入网络smb服务器：
set /p net=IP:
echo set net=%net%>>%path%sti.bat
goto income

:logout
del /q %path%sti.bat
echo set net=%net%>>%path%sti.bat
echo %nick% %user% ^退^出^了^群^聊 >>%net%\temp.txt
cls
echo 请输入用户民：
set /p user=name:
echo set user=%user%>>%path%sti.bat
goto income

:help
cls
echo ============================帮助文档==============================
echo,
echo ^/logout                    退出登陆并要求输入新的用户名
echo ^/win                       分离式窗口(无法使用部分功能)
echo ^/host                      更换新的聊天地址
echo ^/reset                     重置所有设置
echo ^/help                      显示帮助文档
echo ^/exit                      退出聊天
echo, 
echo ============================= 管理员 =============================
echo,
echo ^/cls                       清空聊天内容并保存至历史文件
echo ^/history                   显示历史文件
echo ^/del                       删除历史文件
echo,
echo 按任意键退出帮助界面..........
echo,
echo ==================================================================
pause>NUL
goto scream

:history
if exist "%net%\history.txt" (
	notepad %net%\history.txt
	goto scream
 ) ELSE (
	cls
	echo,
	echo,
	echo,
	echo                          打开历史失败^!
	echo                       文件未创建或无权限
	call:sleep 1
	goto scream
)
goto scream

:license
goto scream

:win_manager
start smbchat win
set win=1
Mode Con: Cols=60 Lines=5
goto scream

:win
cls
echo ==================================================================
type %net%\temp.txt || goto :unfile
echo,
echo ==================================================================
call:sleep 2
goto win

:del_history
if exist "%net%\history.txt" (
	del /q %net%\history.txt
	echo,
	echo,
	echo,
	echo                          删除历史成功^!
	call:sleep 1
	goto scream
 ) ELSE (
	cls
	echo,
	echo,
	echo,
	echo                          删除历史失败^!
	echo                       文件未创建或无权限
	call:sleep 1
	goto scream
)
goto scream

:error_unadmin
cls
echo,
echo,
echo,
echo                          没有管理权限^!
call:sleep 1
goto scream

:exit
echo %nick% %user% ^退^出^了^群^聊 >>%net%\temp.txt
taskkill /f /im cmd.exe

:sleep
set /a n=%1+1
ping -n %n% 127.0.0.1 >nul
goto :eof
