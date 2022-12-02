#Include *i lib\ahk\GUI\FieldViewEditor\FieldViewEditor.ahk

Gui, Main:Tab, 2

#Include *i lib\ahk\GUI\Main\Fields\Field Rotation.ahk
#Include *i lib\ahk\GUI\Main\Fields\Field Settings.ahk

if (!FileExist("lib\ahk\GUI\FieldViewEditor\FieldViewEditor.ahk") || !FileExist("lib\ahk\GUI\Main\Fields\Field Rotation.ahk") || !FileExist("lib\ahk\GUI\Main\Fields\Field Settings.ahk"))
    UnzipFailure()