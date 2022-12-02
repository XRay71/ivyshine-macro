Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x296 y140 w117 h70, Hotkeys
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, xp yp+6, rbxfpsunlocker
Gui, Main:Add, CheckBox, x+10 w25 +Checked%Runrbxfpsunlocker% grbxfpsunlockerUpdated vRunrbxfpsunlocker

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
}

Gui, Main:Add, Text, x302 yp+20, Run at
Gui, Main:Add, Edit, x+4 yp-3 w30 h20 limit3 +Number vFPSLevel gFPSLevelUpdated, 30
Gui, Main:Add, Text, x+4 yp+3, FPS

FPSLevelUpdated() {
    Global FPSLevel
    GuiControlGet, FPSLevel
}

Gui, Main:Add, Button, x302 yp+20 w105 vSaveFPS gSaveFPS, Save FPS

SaveFPS() {
}
