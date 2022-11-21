SendMode Input
SetBatchLines, -1
SetTitleMatchMode, 2
CoordMode, Pixel, Screen

#NoEnv
#Include lib\ahk\constants.ahk
#Include lib\ahk\inireadwrite.ahk

Sleep(duration) {
    DllCall("Sleep", UInt, duration)
}

TimeSince(time) {
    dif := A_NowUTC
    EnvSub, dif, time, Seconds
    Return dif
}

PressM(keys, duration := 20) {
    SetKeyDelay, 5
    for i, key in keys
        Send {%key% Down}
    Sleep(duration)
    for i, key in keys
        Send {%key% Up}
}

PressS(key, duration := 20) {
    SetKeyDelay, 5
    Send {%key% Down}
    Sleep(duration)
    Send {%key% Up}
}

Move(keys, duration := 100) {
    if (keys.Length() != "")
        PressM(keys, duration * DefaultMovespeed/Movespeed)
    else
        PressS(keys, duration * DefaultMovespeed/Movespeed)
}

MoveSquares(keys, blocks := 10) {
    Move(keys, blocks * OneBlockDistance)
}

Jump(duration := 200) {
    PressS("Space", duration)
}

MoveCamera(direction, num := 1) {
    if (direction == "around") {
        Loop, 4
        {
            PressS(CameraRightKey)
        }
    }
    else
    {
        Loop, %num%
        {
            PressS(Camera%direction%Key)
        }
    }
}

PlaceSprinklers(){
    Loop, %NumberOfSprinklers%
    {
        if (SprinklerHotbar != 0){
            PressM(SprinklerHotbar)
            Sleep, 600
            Jump()
            Sleep, 300
        }
        else
        {

        }
    }
}

DeployGlider(midair := True) {
    Jump(50)
    Jump(50)
}

Reset(num := 1, timesleep := 6500) {
    Loop, %num%
    {
        PressS("esc", 50)
        PressS("r", 50)
        PressS("enter", 50)
        Sleep(%timesleep%)
    }
}

ResetKeys(keys := "") {
    for i, key in keys
        Send {%key% Up}
    Click, Up
    Send, {%ForwardKey% up}
    Send, {%LeftKey% up}
    Send, {%RightKey% up}
    Send, {%BackwardKey% up}
    Send, {%CameraLeftKey% up}
    Send, {%CameraRightKey% up}
    Send, {%CameraInKey% up}
    Send, {%CameraOutKey% up}
    Send, {Alt up}
    Send, {Space up}
    Send, {Shift up}
    Send, {Escape up}
    Send, {Control up}
}

SwitchToWindowByExe(process := "RobloxPlayerBeta.exe") {
    Process, Exist, %process%
    if (ErrorLevel == 0)
        return false
    WinActivate, ahk_pid %ErrorLevel%
    WinWaitActive, ahk_pid %ErrorLevel%,,30
    if (ErrorLevel == 1)
        SwitchToWindowByExe(process)
    return true
}

SwitchToWindow(window := "Roblox", exclude := "-")
{
    if (!WinExist(window,,exclude))
        return false
    while(!WinActive(window,,exclude))
        WinActivate, %window%,,%exclude%
    WinWaitActive, %window%,,30,%exclude%
    if (ErrorLevel == 1)
        SwitchToWindow(window, exclude)
    return true
}

KillProcessByExe(process := "RobloxPlayerBeta.exe"){
    Process, Exist, %process%
    PostMessage, 0x0112, 0xF060,,, ahk_pid %ErrorLevel%
    Sleep(100)
    PostMessage, 0x0112, 0xF060,,, ahk_pid %ErrorLevel%
}

CloseRobloxTabs()
{
    while(WinExist("Bee Swarm Simulator"))
    {
        SwitchToWindow("Bee Swarm Simulator", "")
        Send, ^w
        Sleep(200)
    }
    while(WinExist("BSS Rejoin"))
    {
        SwitchToWindow("BSS Rejoin", "")
        Send, ^w
        Sleep(200)
    }
}
