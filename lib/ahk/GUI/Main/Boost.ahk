#Include *i lib\ahk\GUI\EditHotbar\EditHotbar.ahk

Gui, Main:Tab, 3

#Include *i lib\ahk\GUI\Main\Boost\Boost Rotation.ahk
#Include *i lib\ahk\GUI\Main\Boost\Hotbar.ahk
#Include *i lib\ahk\GUI\Main\Boost\Boost Settings.ahk

if (!FileExist("lib\ahk\GUI\Main\Boost\Boost Rotation.ahk") || !FileExist("lib\ahk\GUI\Main\Boost\Hotbar.ahk") || !FileExist("lib\ahk\GUI\EditHotbar\EditHotbar.ahk") || !FileExist("lib\ahk\GUI\Main\Boost\Boost Settings.ahk"))
    UnzipFailure()