#NoEnv                       ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn                        ; Enable warnings to assist with detecting common errors.
#SingleInstance, force       ; Ensure a single instance of this script
SendMode Input               ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx     ; Enable regular expressions in title matches

; Handle installation
installer = %1%
Run, %installer% /loopback_support=no
installerTitle := "i)npcap .* setup"
WinWait, %installerTitle%,,20
WinActivate

exitCode := 1
loop, 50
{
    if WinExist(installerTitle, "i).*license agreement.*")
    {
        BlockInput, On
        WinActivate
        Sleep, 500
        ControlSend,, {Enter}
        Sleep, 500
        ControlSend,, {Enter}
        BlockInput, Off
    }
    if WinExist(installerTitle, "i).*installing.*")
    {
        Sleep, 10000
    }
    if WinExist(installerTitle, "i).*installation complete.*")
    {
        BlockInput, On
        WinActivate
        Sleep, 500
        ControlSend,, {Enter}
        Sleep, 500
        ControlSend,, {Enter}
        BlockInput, Off
        exitCode := 0
        break
    }
    if WinExist(installerTitle, "i).*already installed.*")
    {
        BlockInput, On
        WinActivate
        Sleep, 500
        ControlSend,, {Enter}
        BlockInput, Off
        exitCode := 0
        break
    }
    Sleep, 1000
}
ExitApp %exitCode%
