OnExit("MainGuiClose")
Gui, Main:-MaximizeBox +Border

if (StrLen(StartHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, x430 y326 w30 vStartHotkeyButtonMain gStartMacro, %StartHotkey%

if (StrLen(PauseHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, xp+30 yp wp vPauseHotkeyButtonMain gPauseMacro, %PauseHotkey%

if (StrLen(StopHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, xp+30 yp wp vStopHotkeyButtonMain gStopMacro, %StopHotkey%

Gui, Main:Font
Gui, Main:Add, Text, x520 y335 w28 Right, % "v" MacroVersion

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, Tab3, hWndhTab x0 y0 w550 h350 vCurrentTab gMainTabUpdated -Wrap +0x8 +Bottom, % StrReplace("Settings|Fields|Boost|Mobs|Quests|Planters|Stats|", CurrentTab, CurrentTab "|")

if (!FileExist("lib\ahk\GUI\Main\Settings.ahk") || !FileExist("lib\ahk\GUI\Main\Fields.ahk"))
    UnzipFailure()

#Include *i lib\ahk\GUI\Main\Settings.ahk
#Include *i lib\ahk\GUI\Main\Fields.ahk

Gui, Main:Show, x%GuiX% y%GuiY% w550 h350, Ivyshine Macro

MainTabUpdated() {
    Global CurrentTab
    GuiControlGet, CurrentTab
    if (CurrentTab != "Settings")
        Gui, EditHotkeys:Cancel
    else if (CurrentTab != "Fields")
        Gui, FieldViewEditor:Destroy
    GuiToAllInis()
}