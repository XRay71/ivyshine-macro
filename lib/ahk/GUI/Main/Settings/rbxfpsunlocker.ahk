Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x296 y140 w117 h96, rbxfpsunlocker
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, xp yp+6, Rbxfpsunlocker
Gui, Main:Add, CheckBox, x+6 w25 +Checked%Runrbxfpsunlocker% vRunrbxfpsunlocker grbxfpsunlockerUpdated

rbxfpsunlockerUpdated() {
    Global Runrbxfpsunlocker
    Global FPSLevel
    GuiControlGet, Runrbxfpsunlocker
    GuiControlGet, FPSLevel
    if (!Runrbxfpsunlocker)
    {
        GuiControl, Main:Disable, FPSLevel
        GuiControl, Main:Disable, SaveFPS
        Process, Close, rbxfpsunlocker.exe
        Process, WaitClose, rbxfpsunlocker.exe, 2
        FileDelete, lib\rbxfpsunlocker\settings
    } else {
        GuiControl, Main:Enable, FPSLevel
        GuiControl, Main:Enable, SaveFPS
        RunFPS(FPSLevel)
    }
    GuiToAllInis()
}

Gui, Main:Add, Text, x302 yp+20, Run at
if (Runrbxfpsunlocker)
    Gui, Main:Add, Edit, x+4 yp-3 w30 h20 limit3 +Number vFPSLevel gFPSLevelUpdated, 30
else
    Gui, Main:Add, Edit, x+4 yp-3 w30 h20 limit3 +Number Disabled vFPSLevel gFPSLevelUpdated, 30
Gui, Main:Add, Text, x+4 yp+3, FPS

FPSLevelUpdated() {
    Global FPSLevel
    GuiControlGet, FPSLevel
    if (!FPSLevel && FPSLevel != 0) {
        FPSLevel := 0
        GuiControl, Main:Text, FPSLevel, %FPSLevel%
    }
    if (FPSLevel)
        GuiToAllInis()
}

if (Runrbxfpsunlocker)
    Gui, Main:Add, Button, x302 yp+20 w105 vSaveFPS gSaveFPS, Save FPS
else
    Gui, Main:Add, Button, x302 yp+20 w105 Disabled vSaveFPS gSaveFPS, Save FPS

SaveFPS() {
    Global Runrbxfpsunlocker
    Global FPSLevel
    if (!FPSLevel) {
        MsgBox, 276, Warning!, Are you sure you want to run Roblox at unlimited FPS? This will strain your computer.
        IfMsgBox, No
        Return
    }
    
    if (Runrbxfpsunlocker)
        RunFPS(FPSLevel)
}

RunFPS(FPS := 30) {
    Process, Close, rbxfpsunlocker.exe
    if (!FPS)
        FPSCapSelection := 0
    else
        FPSCapSelection := 1
    FileDelete, lib\rbxfpsunlocker\settings
    FileAppend,
    (
UnlockClient=true
UnlockStudio=false
FPSCapValues=[%FPS%]
FPSCapSelection=%FPSCapSelection%
FPSCap=%FPS%
CheckForUpdates=false
NonBlockingErrors=true
SilentErrors=true
QuickStart=true
    ), lib\rbxfpsunlocker\settings
    Run, lib\rbxfpsunlocker\rbxfpsunlocker.exe, lib\rbxfpsunlocker, Hide
}