Gui, EditHotkeys:+ownerMain +ToolWindow
Gui, EditHotkeys:Add, Text, x4 y7, Start

Gui, EditHotkeys:Add, Hotkey, x40 yp-3 vStartHotkeyTemp, % StartHotkey == StrReplace(StartHotkey, "#") ? StartHotkey : SubStr(StartHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 yp+3 vStartWinKey, WinKey
GuiControl, EditHotkeys:, StartWinKey, % StartHotkey != StrReplace(StartHotkey, "#")

Gui, EditHotkeys:Add, Text, x4 yp+24, Pause
Gui, EditHotkeys:Add, Hotkey, x40 yp-3 vPauseHotkeyTemp, % PauseHotkey == StrReplace(PauseHotkey, "#") ? PauseHotkey : SubStr(PauseHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 yp+3 vPauseWinKey, WinKey
GuiControl, EditHotkeys:, PauseWinKey, % PauseHotkey != StrReplace(PauseHotkey, "#")

Gui, EditHotkeys:Add, Text, x4 yp+24, Stop
Gui, EditHotkeys:Add, Hotkey, x40 yp-3 vStopHotkeyTemp, % StopHotkey == StrReplace(StopHotkey, "#") ? StopHotkey : SubStr(StopHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 yp+3 vStopWinKey, WinKey
GuiControl, EditHotkeys:, StopWinKey, % Stophotkey != StrReplace(Stophotkey, "#")

Gui, EditHotkeys:Add, Button, x10 yp+24 w215 gSaveEditedHotkeys, Save

SaveEditedHotkeys() {
    Global StartHotkey
    Global PauseHotkey
    Global StopHotkey
    
    Hotkey, %StartHotkey%, Off
    Hotkey, %PauseHotkey%, Off
    Hotkey, %StopHotkey%, Off
    
    GuiControlGet, StartHotkeyTemp
    GuiControlGet, PauseHotkeyTemp
    GuiControlGet, StopHotkeyTemp
    
    GuiControlGet, StartWinKey
    GuiControlGet, PauseWinKey
    GuiControlGet, StopWinKey
    
    if (StartHotkeyTemp == "" || PauseHotkeyTemp == "" || StopHotkeyTemp == ""){
        MsgBox, 4112, Error, Hotkeys cannot be blank!
        Return
    }
    
    if (StartWinKey)
        StartHotkeyTemp := "#" StartHotkeyTemp
    if (PauseWinKey)
        PauseHotkeyTemp := "#" PauseHotkeyTemp
    if (StopWinKey)
        StopHotkeyTemp := "#" StopHotkeyTemp
    
    Hotkey, %StartHotkeyTemp%, StartMacro, On
    Hotkey, %PauseHotkeyTemp%, PauseMacro, On
    Hotkey, %StopHotkeyTemp%, StopMacro, On
    
    IniWrite, %StartHotkeyTemp%, % IniPaths["Config"], Keybinds, StartHotkey
    IniWrite, %PauseHotkeyTemp%, % IniPaths["Config"], Keybinds, PauseHotkey
    IniWrite, %StopHotkeyTemp%, % IniPaths["Config"], Keybinds, StopHotkey
    
    if (SubStr(StartHotkey, 1, 1) == "~")
        StartHotkey :=
    
    if (StrLen(StartHotkeyTemp) < 5)
        Gui, Main:Font
    else
        Gui, Main:Font, s6
    GuiControl, Main:Font, StartHotkeyButtonMain
    
    if (StrLen(PauseHotkeyTemp) < 5)
        Gui, Main:Font
    else
        Gui, Main:Font, s6
    GuiControl, Main:Font, PauseHotkeyButtonMain
    
    if (StrLen(StopHotkeyTemp) < 5)
        Gui, Main:Font
    else
        Gui, Main:Font, s6
    GuiControl, Main:Font, StopHotkeyButtonMain
    
    GuiControl, Main:Text, StartHotkeyButtonMain, %StartHotkeyTemp%
    GuiControl, Main:Text, PauseHotkeyButtonMain, %PauseHotkeyTemp%
    GuiControl, Main:Text, StopHotkeyButtonMain, %StopHotkeyTemp%
    
    GuiControl, Main:Text, StartHotkeyButtonSettings, Start (%StartHotkeyTemp%)
    GuiControl, Main:Text, PauseHotkeyButtonSettings, Pause (%PauseHotkeyTemp%)
    GuiControl, Main:Text, StopHotkeyButtonSettings, Stop (%StopHotkeyTemp%)
    
    StartHotkey := StartHotkeyTemp
    PauseHotkey := PauseHotkeyTemp
    StopHotkey := StopHotkeyTemp
    
    Gui, EditHotkeys:Hide
}

EditHotkeysGuiClose() {
    Global StartHotkey
    Global PauseHotkey
    Global StopHotkey
    
    GuiControl, EditHotkeys:Text, StartHotkeyTemp, %StartHotkey%
    GuiControl, EditHotkeys:Text, PauseHotkeyTemp, %PauseHotkey%
    GuiControl, EditHotkeys:Text, StopHotkeyTemp, %StopHotkey%
    
    Hotkey, %StartHotkey%, StartMacro, On
    Hotkey, %PauseHotkey%, PauseMacro, On
    Hotkey, %StopHotkey%, StopMacro, On
}