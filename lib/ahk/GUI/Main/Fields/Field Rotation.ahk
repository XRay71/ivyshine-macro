Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y8 w220 h306, Field Rotation
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y33 w80 Center, Selected
Gui, Main:Add, Text, x136 yp wp Center, Not Selected
Gui, Main:Add, ListBox, x16 y50 wp h230 vCurrentlySelectedField gFieldSelectionUpdated, % StrReplace(FieldRotationList, CurrentlySelectedField, CurrentlySelectedField "|")

FieldSelectionUpdated() {
    Global CurrentlySelectedField
    GuiControlGet, CurrentlySelectedField
    GuiToAllInis()
}

Gui, Main:Add, ListBox, x136 yp wp h230 +Sort vAddToRotation gAddToRotationUpdated, %NonRotationList%

AddToRotationUpdated() {
    Global AddToRotation
    GuiControlGet, AddToRotation
}

Gui, Main:Add, Button, x104 y100 w24 gAddFieldRotation, <-

AddFieldRotation() {
    Global FieldRotationList
    Global AddToRotation
    Global NonRotationList
    GuiControlGet, AddToRotation
    if (AddToRotation != "") {
        FieldRotationList .= AddToRotation "|"
        CurrentlySelectedField := AddToRotation
        NonRotationList := StrReplace(NonRotationList, AddToRotation "|")
        
        DoGather := 1
        
        IniWrite, %DoGather%, % IniPaths["FieldConfig"], Config, DoGather
        IniWrite, %FieldRotationList%, % IniPaths["FieldConfig"], Config, FieldRotationList
        IniWrite, %CurrentlySelectedField%, % IniPaths["FieldConfig"], Config, CurrentlySelectedField
        IniWrite, %NonRotationList%, % IniPaths["FieldConfig"], Config, NonRotationList
        
        GuiControl,, CurrentlySelectedField, % "|" StrSplit(FieldRotationList, CurrentlySelectedField)[1] CurrentlySelectedField "|" StrSplit(FieldRotationList, CurrentlySelectedField)[2]
        GuiControl,, AddToRotation, % "|" NonRotationList
    }
}

Gui, Main:Add, Button, xp yp+24 wp gRemoveFieldRotation, ->

RemoveFieldRotation() {
    Global FieldRotationList
    Global NonRotationList
    Global CurrentlySelectedField
    GuiControlGet, CurrentlySelectedField
    if (CurrentlySelectedField != "") {
        NonRotationList := StrReplace(NonRotationList, "||", "|") CurrentlySelectedField "|"
        FieldRotationList := StrReplace(FieldRotationList, CurrentlySelectedField "|")
        CurrentlySelectedField := ""
        
        if (FieldRotationList == "")
            DoGather := 0
        else
            DoGather := 1
        
        IniWrite, %DoGather%, % IniPaths["FieldConfig"], Config, DoGather
        IniWrite, %FieldRotationList%, % IniPaths["FieldConfig"], Config, FieldRotationList
        IniWrite, %CurrentlySelectedField%, % IniPaths["FieldConfig"], Config, CurrentlySelectedField
        IniWrite, %NonRotationList%, % IniPaths["FieldConfig"], Config, NonRotationList
        
        GuiControl, Main:Text, CurrentlySelectedField, % "|" FieldRotationList
        GuiControl, Main:Text, AddToRotation, % "|" NonRotationList
    }
}

Gui, Main:Add, Button, xp y156 wp gMoveFieldRotationUp, /\

MoveFieldRotationUp() {
    ReadFromAllInis()
    Global FieldRotationList
    Global CurrentlySelectedField
    GuiControlGet, CurrentlySelectedField
    if (CurrentlySelectedField != "" && InStr(FieldRotationList, CurrentlySelectedField) != 1) {
        FieldRotationList := SubStr(FieldRotationList, 1, InStr(SubStr(FieldRotationList, 1, InStr(FieldRotationList, CurrentlySelectedField "|") - 1), "|",, -1)) CurrentlySelectedField StrReplace(SubStr("|" FieldRotationList, InStr("|" SubStr(FieldRotationList, 1, InStr(FieldRotationList, CurrentlySelectedField "|") - 1), "|",, -1)), CurrentlySelectedField "|")
        IniWrite, %FieldRotationList%, % IniPaths["FieldConfig"], Config, FieldRotationList
        GuiControl, Main:Text, CurrentlySelectedField, % "|" StrReplace(FieldRotationList, CurrentlySelectedField, CurrentlySelectedField "|")
    }
}

Gui, Main:Add, Button, xp yp+24 wp gMoveFieldRotationDown, \/

MoveFieldRotationDown() {
    ReadFromAllInis()
    Global FieldRotationList
    Global CurrentlySelectedField
    GuiControlGet, CurrentlySelectedField
    if (CurrentlySelectedField != "" && InStr(FieldRotationList, CurrentlySelectedField,, 0) - 1 != StrLen(FieldRotationList) - StrLen(CurrentlySelectedField "|") && StrLen(FieldRotationList) - StrLen(CurrentlySelectedField "|") > 0) {
        FieldRotationList := StrReplace(SubStr(StrSplit(FieldRotationList, CurrentlySelectedField "|")[2], InStr(StrSplit(FieldRotationList, CurrentlySelectedField "|")[2], "|")) == "|" ? FieldRotationList : StrReplace(FieldRotationList, SubStr(StrSplit(FieldRotationList, CurrentlySelectedField "|")[2], InStr(StrSplit(FieldRotationList, CurrentlySelectedField "|")[2], "|"))) "|", CurrentlySelectedField "|") CurrentlySelectedField SubStr(StrSplit(FieldRotationList, CurrentlySelectedField "|")[2], InStr(StrSplit(FieldRotationList, CurrentlySelectedField "|")[2], "|"))
        IniWrite, %FieldRotationList%, % IniPaths["FieldConfig"], Config, FieldRotationList
        GuiControl, Main:Text, CurrentlySelectedField, % "|" StrReplace(FieldRotationList, CurrentlySelectedField, CurrentlySelectedField "|")
    }
}

Gui, Main:Add, Button, x16 y280 w200 h26, Reset Selected Field to Defaults
