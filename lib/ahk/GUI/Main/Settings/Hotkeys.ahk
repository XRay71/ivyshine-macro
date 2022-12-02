Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x296 y8 w117 h130, Hotkeys
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Button, xp y35 w101 vStartHotkeyButtonSettings gStartMacro, Start (%StartHotkey%)
Gui, Main:Add, Button, xp yp+24 wp vPauseHotkeyButtonSettings gPauseMacro, Pause (%PauseHotkey%)
Gui, Main:Add, Button, xp yp+24 wp vStopHotkeyButtonSettings gStopMacro, Stop (%StopHotkey%)

Gui, Main:Add, Button, xp yp+24 wp gEditHotkeys, Edit Hotkeys

EditHotkeys() {
    Gui, EditHotkeys:Show,, Edit Hotkeys
}

#Include lib\ahk\GUI\EditHotkeys\edithotkeys.ahk

Hotkey, %StartHotkey%, StartMacro, On
Hotkey, %PauseHotkey%, PauseMacro, On
Hotkey, %StopHotkey%, StopMacro, On
