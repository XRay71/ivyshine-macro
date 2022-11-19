SendMode Input
SetBatchLines, -1
SetTitleMatchMode, 2
CoordMode, Pixel, Screen

#NoEnv
#Include constants.ahk
#Include, inireadwrite.ahk

Sleep(duration) {
    DllCall("Sleep", UInt, duration)
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
        PressM(keys, duration * movespeed/basemovespeed)
    else
        PressS(keys, duration * movespeed/basemovespeed)
}

MoveSquares(keys, blocks := 10) {
    Move(keys, blocks * oneblockdistance)
}

Jump(duration := 200) {
    PressS("Space", duration)
}

MoveCamera(direction, num := 1) {
    if (direction == "around") {
        Loop, 4
        {
            PressS(CameraRight)
        }
    }
    else
    {
        Loop, %num%
        {
            PressS(Camera%direction%)
        }
    }
}

PlaceSprinklers(){
    Loop, %numberofsprinklers%
    {
        if (sprinklerhotbar !=0)
        {
            PressM(sprinklerhotbar)
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
        PressM("esc")
        PressM("r")
        PressM("enter")
        Sleep(%timesleep%)
    }
}

ResetKeys(keys := "") {
    for i, key in keys
        Send {%key% Up}
    Click, Up
    Send, {w up}
    Send, {a up}
    Send, {s up}
    Send, {d up}
    Send, {Alt up}
    Send, {Space up}
    Send, {Shift up}
    Send, {Escape up}
    Send, {Control up}
}

SwitchToWindow(window := "Roblox", exclude := "-")
{
    if (!WinExist(window,,exclude))
    {
        return, false
    }
    while(!WinActive(window,,exclude))
    {
        WinActivate, %window%,,%exclude%
    }
    WinWaitActive, %window%,,30,%exclude%
    if (ErrorLevel=1)
    {
        SwitchToWindow(window, exclude)
    }
    return, true
}

KillProcessByExe(process := "RobloxPlayerBeta.exe") {
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
        Sleep, 200
    }
    while(WinExist("BSS Rejoin"))
    {
        SwitchToWindow("BSS Rejoin", "")
        Send, ^w
        Sleep, 200
    }
}