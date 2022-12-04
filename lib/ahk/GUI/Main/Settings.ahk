Gui, Main:Tab, 1

#Include *i lib\ahk\GUI\Main\Settings\Basic Config.ahk
#Include *i lib\ahk\GUI\Main\Settings\Unlocks.ahk
#Include *i lib\ahk\GUI\Main\Settings\Bees.ahk
#Include *i lib\ahk\GUI\Main\Settings\Hotkeys.ahk
#Include *i lib\ahk\GUI\Main\Settings\rbxfpsunlocker.ahk
#Include *i lib\ahk\GUI\Main\Settings\Keybinds.ahk

if (!FileExist("lib\ahk\GUI\Main\Settings\Basic Config.ahk") || !FileExist("lib\ahk\GUI\Main\Settings\Unlocks.ahk") || !FileExist("lib\ahk\GUI\Main\Settings\Bees.ahk") || !FileExist("lib\ahk\GUI\Main\Settings\Hotkeys.ahk") || !FileExist("lib\ahk\GUI\Main\Settings\rbxfpsunlocker.ahk") || !FileExist("lib\ahk\GUI\Main\Settings\Keybinds.ahk"))
    UnzipFailure()

Gui, Main:Add, Button, vRestoreDefaultSettings x424 y280 w116 h33 gResetAllDefaults, Restore Defaults

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
