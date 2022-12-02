Gui, Main:Tab, 1

#Include lib\ahk\GUI\Main\Settings\Basic Config.ahk
#Include lib\ahk\GUI\Main\Settings\Unlocks.ahk
#Include lib\ahk\GUI\Main\Settings\Bees.ahk
#Include lib\ahk\GUI\Main\Settings\Hotkeys.ahk
#Include lib\ahk\GUI\Main\Settings\rbxfpsunlocker.ahk
#Include lib\ahk\GUI\Main\Settings\Keybinds.ahk

Gui, Main:Add, Button, hWndhBtnRestoreDefaults x424 y280 w116 h33 gResetAllDefaults, Restore Defaults

ResetAllDefaults() {
    MsgBox, 305, Warning!, This will reset the entire macro to its default settings`, excluding stats.
    IfMsgBox, OK
    {
        for ini in AllVars
            if (ini != "Stats")
                CreateIni(ini)
        Reload
    }
}
