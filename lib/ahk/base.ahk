#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1

#Include, ..\init\constants.ahk

Sleep(duration) {
    DllCall("Sleep", UInt, duration)
}

Press(keys, duration := 100) {
    SetKeyDelay, 5
    for i, key in keys
    Send {%key% Down}
    Sleep(duration)
    for i, key in keys
    Send {%key% Up}
}

Jump(duration := 300) {
    Press(["Space"], duration)
}

DeployGlider(midair := True) {
    Jump(50)
    Jump(50)
}

Reset(num := 1) {
    Loop, %num%
    {
        Press(["esc"])
        Press(["r"])
        Press(["enter"])
    }
}