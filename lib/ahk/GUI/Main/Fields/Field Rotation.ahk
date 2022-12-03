Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y8 w220 h306, Field Rotation
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y33 w80 Center, Selected
Gui, Main:Add, Text, x136 yp wp Center, Not Selected
Gui, Main:Add, ListBox, x16 y50 wp h230 vCurrentlySelectedField gFieldSelectionUpdated, % StrReplace(FieldRotationList, CurrentlySelectedField, CurrentlySelectedField "|")

FieldSelectionUpdated() {
    Global
    GuiControlGet, CurrentlySelectedField
    CurrentlySelectedFieldName := StrSplit(CurrentlySelectedField, " ")[1]
    if (CurrentlySelectedFieldName != "") {
        GuiControl, Main:Enable, GatherPattern
        GuiControl, Main:Enable, GatherSize
        GuiControl, Main:Enable, GatherWidth
        GuiControl, Main:Enable, GatherShiftLockEnabled
        GuiControl, Main:Enable, InvertFB
        GuiControl, Main:Enable, InvertRL
        GuiControl, Main:Enable, GatherTime
        GuiControl, Main:Enable, BagPercent
        GuiControl, Main:Enable, GatherStartPosition
        GuiControl, Main:Enable, GatherReturnMethod
        GuiControl, Main:Enable, GatherTurn
        
        GuiControl, Main:ChooseString, GatherPattern, % GatherPattern%CurrentlySelectedFieldName%
        GuiControl, Main:ChooseString, GatherSize, % GatherSize%CurrentlySelectedFieldName%
        GuiControl, Main:ChooseString, GatherWidth, % GatherWidth%CurrentlySelectedFieldName%
        GuiControl,, GatherShiftLockEnabled, % GatherShiftLockEnabled%CurrentlySelectedFieldName%
        GuiControl,, InvertFB, % InvertFB%CurrentlySelectedFieldName%
        GuiControl,, InvertRL, % InvertRL%CurrentlySelectedFieldName%
        GuiControl, Main:Text, GatherTime, % GatherTime%CurrentlySelectedFieldName%
        GuiControl, Main:Text, BagPercent, % BagPercent%CurrentlySelectedFieldName%
        GuiControl, Main:ChooseString, GatherStartPosition, % GatherStartPosition%CurrentlySelectedFieldName%
        GuiControl, Main:ChooseString, GatherReturnMethod, % GatherReturnMethod%CurrentlySelectedFieldName%
        GuiControl, Main:ChooseString, GatherTurn, % GatherTurn%CurrentlySelectedFieldName%
        if (GatherTurn%CurrentlySelectedFieldName% == "None")
            GuiControl, Main:Disable, GatherTurnTimes
        else
            GuiControl, Enable, GatherTurnTimes
        GuiControl, Main:Text, GatherTurnTimes, % "|" StrReplace("0|1|2|3|4|", GatherTurnTimes%CurrentlySelectedFieldName%, GatherTurnTimes%CurrentlySelectedFieldName% "|")
    } else {
        GuiControl, Main:Disable, GatherPattern
        GuiControl, Main:Disable, GatherSize
        GuiControl, Main:Disable, GatherWidth
        GuiControl, Main:Disable, GatherShiftLockEnabled
        GuiControl, Main:Disable, InvertFB
        GuiControl, Main:Disable, InvertRL
        GuiControl, Main:Disable, GatherTime
        GuiControl, Main:Disable, BagPercent
        GuiControl, Main:Disable, GatherStartPosition
        GuiControl, Main:Disable, GatherReturnMethod
        GuiControl, Main:Disable, GatherTurn
        GuiControl, Main:Disable, GatherTurnTimes
    }
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
        FieldSelectionUpdated()
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
        FieldSelectionUpdated()
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

Gui, Main:Add, Button, x16 y280 w200 h26 gResetCurrentField, Reset Selected Field to Defaults

ResetCurrentField() {
    Global
    GuiControlGet, CurrentlySelectedField
    CurrentlySelectedFieldName := StrSplit(CurrentlySelectedField, " ")[1]
    if (CurrentlySelectedFieldName != "") {
        GatherPattern%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherPattern" CurrentlySelectedFieldName]
        GatherSize%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherSize" CurrentlySelectedFieldName]
        GatherWidth%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherWidth" CurrentlySelectedFieldName]
        GatherShiftLockEnabled%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherShiftLockEnabled" CurrentlySelectedFieldName]
        InvertFB%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["InvertFB" CurrentlySelectedFieldName]
        InvertRL%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["InvertRL" CurrentlySelectedFieldName]
        GatherTime%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherTime" CurrentlySelectedFieldName]
        BagPercent%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["BagPercent" CurrentlySelectedFieldName]
        GatherStartPosition%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherStartPosition" CurrentlySelectedFieldName]
        GatherReturnMethod%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherReturnMethod" CurrentlySelectedFieldName]
        GatherTurn%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherTurn" CurrentlySelectedFieldName]
        GatherTurnTimes%CurrentlySelectedFieldName% := AllVars["FieldConfig"][CurrentlySelectedFieldName]["GatherTurnTimes" CurrentlySelectedFieldName]
        IniWrite, % GatherPattern%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherPattern" CurrentlySelectedFieldName
        IniWrite, % GatherSize%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherSize" CurrentlySelectedFieldName
        IniWrite, % GatherWidth%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherWidth" CurrentlySelectedFieldName
        IniWrite, % GatherShiftLockEnabled%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherShiftLockEnabled" CurrentlySelectedFieldName
        IniWrite, % InvertFB%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "InvertFB" CurrentlySelectedFieldName
        IniWrite, % InvertRL%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "InvertRL" CurrentlySelectedFieldName
        IniWrite, % GatherTime%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherTime" CurrentlySelectedFieldName
        IniWrite, % BagPercent%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "BagPercent" CurrentlySelectedFieldName
        IniWrite, % GatherStartPosition%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherStartPosition" CurrentlySelectedFieldName
        IniWrite, % GatherReturnMethod%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherReturnMethod" CurrentlySelectedFieldName
        IniWrite, % GatherTurn%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherTurn" CurrentlySelectedFieldName
        IniWrite, % GatherTurnTimes%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherTurnTimes" CurrentlySelectedFieldName
        FieldSelectionUpdated()
    }
}