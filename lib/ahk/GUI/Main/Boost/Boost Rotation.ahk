Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y8 w220 h306, Consumables List
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y33 w80 Center, Selected
Gui, Main:Add, Text, x136 yp wp Center, Not Selected
Gui, Main:Add, ListBox, x16 y50 wp h230 +Sort vCurrentlySelectedBoost gBoostSelectionUpdated, % StrReplace(BoostRotationList, CurrentlySelectedBoost, CurrentlySelectedBoost "|")

BoostSelectionUpdated() {
    Global
    GuiControlGet, CurrentlySelectedBoost
    CurrentlySelectedBoostName := StrSplit(CurrentlySelectedBoost, " ")[1]
    ; if (CurrentlySelectedBoostName != "") {
    ;     GuiControl, Main:Enable, GatherPattern
    ;     GuiControl, Main:Enable, GatherSize
    ;     GuiControl, Main:Enable, GatherWidth
    ;     GuiControl, Main:Enable, GatherShiftLockEnabled
    ;     GuiControl, Main:Enable, InvertFB
    ;     GuiControl, Main:Enable, InvertRL
    ;     GuiControl, Main:Enable, GatherTime
    ;     GuiControl, Main:Enable, BagPercent
    ;     GuiControl, Main:Enable, GatherStartPosition
    ;     GuiControl, Main:Enable, GatherReturnMethod
    ;     GuiControl, Main:Enable, GatherTurn
    
    ;     GuiControl, Main:ChooseString, GatherPattern, % GatherPattern%CurrentlySelectedBoostName%
    ;     GuiControl, Main:ChooseString, GatherSize, % GatherSize%CurrentlySelectedBoostName%
    ;     GuiControl, Main:ChooseString, GatherWidth, % GatherWidth%CurrentlySelectedBoostName%
    ;     GuiControl,, GatherShiftLockEnabled, % GatherShiftLockEnabled%CurrentlySelectedBoostName%
    ;     GuiControl,, InvertFB, % InvertFB%CurrentlySelectedBoostName%
    ;     GuiControl,, InvertRL, % InvertRL%CurrentlySelectedBoostName%
    ;     GuiControl, Main:Text, GatherTime, % GatherTime%CurrentlySelectedBoostName%
    ;     GuiControl, Main:Text, BagPercent, % BagPercent%CurrentlySelectedBoostName%
    ;     GuiControl, Main:ChooseString, GatherStartPosition, % GatherStartPosition%CurrentlySelectedBoostName%
    ;     GuiControl, Main:ChooseString, GatherReturnMethod, % GatherReturnMethod%CurrentlySelectedBoostName%
    ;     GuiControl, Main:ChooseString, GatherTurn, % GatherTurn%CurrentlySelectedBoostName%
    ;     if (GatherTurn%CurrentlySelectedBoostName% == "None")
    ;         GuiControl, Main:Disable, GatherTurnTimes
    ;     else
    ;         GuiControl, Enable, GatherTurnTimes
    ;     GuiControl, Main:Text, GatherTurnTimes, % "|" StrReplace("0|1|2|3|4|", GatherTurnTimes%CurrentlySelectedBoostName%, GatherTurnTimes%CurrentlySelectedBoostName% "|")
    ; } else {
    ;     GuiControl, Main:Disable, GatherPattern
    ;     GuiControl, Main:Disable, GatherSize
    ;     GuiControl, Main:Disable, GatherWidth
    ;     GuiControl, Main:Disable, GatherShiftLockEnabled
    ;     GuiControl, Main:Disable, InvertFB
    ;     GuiControl, Main:Disable, InvertRL
    ;     GuiControl, Main:Disable, GatherTime
    ;     GuiControl, Main:Disable, BagPercent
    ;     GuiControl, Main:Disable, GatherStartPosition
    ;     GuiControl, Main:Disable, GatherReturnMethod
    ;     GuiControl, Main:Disable, GatherTurn
    ;     GuiControl, Main:Disable, GatherTurnTimes
    ; }
    GuiToAllInis()
}

Gui, Main:Add, ListBox, x136 yp wp h230 +Sort vAddToBoostRotation gAddToBoostRotationUpdated, %NonBoostRotationList%

AddToBoostRotationUpdated() {
    Global AddToBoostRotation
    GuiControlGet, AddToBoostRotation
}

Gui, Main:Add, Button, x104 y142 w24 vAddBoostRotationButton gAddBoostRotation, <-

AddBoostRotation() {
    Global BoostRotationList
    Global AddToBoostRotation
    Global NonBoostRotationList
    Global DoBoost
    GuiControlGet, AddToBoostRotation
    if (AddToBoostRotation != "") {
        BoostRotationList .= AddToBoostRotation "|"
        CurrentlySelectedBoost := AddToBoostRotation
        NonBoostRotationList := StrReplace(NonBoostRotationList, AddToBoostRotation "|")
        
        DoBoost := 1
        
        IniWrite, %DoBoost%, % IniPaths["BoostConfig"], Config, DoBoost
        IniWrite, %BoostRotationList%, % IniPaths["BoostConfig"], Config, BoostRotationList
        IniWrite, %CurrentlySelectedBoost%, % IniPaths["BoostConfig"], Config, CurrentlySelectedBoost
        IniWrite, %NonBoostRotationList%, % IniPaths["BoostConfig"], Config, NonBoostRotationList
        
        GuiControl,, CurrentlySelectedBoost, % "|" StrReplace(BoostRotationList, CurrentlySelectedBoost, CurrentlySelectedBoost "|")
        GuiControl,, AddToBoostRotation, % "|" NonBoostRotationList
        BoostSelectionUpdated()
    }
}

Gui, Main:Add, Button, xp yp+24 wp vRemoveBoostRotationButton gRemoveBoostRotation, ->

RemoveBoostRotation() {
    Global BoostRotationList
    Global NonBoostRotationList
    Global CurrentlySelectedBoost
    Global DoBoost
    GuiControlGet, CurrentlySelectedBoost
    if (CurrentlySelectedBoost != "") {
        NonBoostRotationList := StrReplace(NonBoostRotationList, "||", "|") CurrentlySelectedBoost "|"
        BoostRotationList := StrReplace(BoostRotationList, CurrentlySelectedBoost "|")
        CurrentlySelectedBoost := ""
        
        if (BoostRotationList == "")
            DoBoost := 0
        else
            DoBoost := 1
        
        IniWrite, %DoBoost%, % IniPaths["BoostConfig"], Config, DoBoost
        IniWrite, %BoostRotationList%, % IniPaths["BoostConfig"], Config, BoostRotationList
        IniWrite, %CurrentlySelectedBoost%, % IniPaths["BoostConfig"], Config, CurrentlySelectedBoost
        IniWrite, %NonBoostRotationList%, % IniPaths["BoostConfig"], Config, NonBoostRotationList
        
        GuiControl, Main:Text, CurrentlySelectedBoost, % "|" BoostRotationList
        GuiControl, Main:Text, AddToboostRotation, % "|" NonBoostRotationList
        BoostSelectionUpdated()
    }
}

Gui, Main:Add, Button, x16 y280 w200 h26 vResetCurrentBoostButton gResetCurrentBoost, Reset Selected Field to Defaults

ResetCurrentBoost() {
    Global
    GuiControlGet, CurrentlySelectedBoost
    CurrentlySelectedBoostName := StrSplit(CurrentlySelectedBoost, " ")[1]
    ; if (CurrentlySelectedBoostName != "") {
    ;     GatherPattern%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherPattern" CurrentlySelectedBoostName]
    ;     GatherSize%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherSize" CurrentlySelectedBoostName]
    ;     GatherWidth%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherWidth" CurrentlySelectedBoostName]
    ;     GatherShiftLockEnabled%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherShiftLockEnabled" CurrentlySelectedBoostName]
    ;     InvertFB%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["InvertFB" CurrentlySelectedBoostName]
    ;     InvertRL%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["InvertRL" CurrentlySelectedBoostName]
    ;     GatherTime%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherTime" CurrentlySelectedBoostName]
    ;     BagPercent%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["BagPercent" CurrentlySelectedBoostName]
    ;     GatherStartPosition%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherStartPosition" CurrentlySelectedBoostName]
    ;     GatherReturnMethod%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherReturnMethod" CurrentlySelectedBoostName]
    ;     GatherTurn%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherTurn" CurrentlySelectedBoostName]
    ;     GatherTurnTimes%CurrentlySelectedBoostName% := AllVars["BoostConfig"][CurrentlySelectedBoostName]["GatherTurnTimes" CurrentlySelectedBoostName]
    ;     IniWrite, % GatherPattern%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherPattern" CurrentlySelectedBoostName
    ;     IniWrite, % GatherSize%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherSize" CurrentlySelectedBoostName
    ;     IniWrite, % GatherWidth%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherWidth" CurrentlySelectedBoostName
    ;     IniWrite, % GatherShiftLockEnabled%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherShiftLockEnabled" CurrentlySelectedBoostName
    ;     IniWrite, % InvertFB%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "InvertFB" CurrentlySelectedBoostName
    ;     IniWrite, % InvertRL%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "InvertRL" CurrentlySelectedBoostName
    ;     IniWrite, % GatherTime%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherTime" CurrentlySelectedBoostName
    ;     IniWrite, % BagPercent%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "BagPercent" CurrentlySelectedBoostName
    ;     IniWrite, % GatherStartPosition%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherStartPosition" CurrentlySelectedBoostName
    ;     IniWrite, % GatherReturnMethod%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherReturnMethod" CurrentlySelectedBoostName
    ;     IniWrite, % GatherTurn%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherTurn" CurrentlySelectedBoostName
    ;     IniWrite, % GatherTurnTimes%CurrentlySelectedBoostName%, %path%, %CurrentlySelectedBoostName%, % "GatherTurnTimes" CurrentlySelectedBoostName
    ;     FieldSelectionUpdated()
    ; }
}