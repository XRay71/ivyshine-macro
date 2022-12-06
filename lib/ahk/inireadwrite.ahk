Global IniPaths := {"Config":A_ScriptDir "\lib\init\config.ini"
    , "FieldConfig":A_ScriptDir "\lib\init\fields.ini"
    , "BoostConfig":A_ScriptDir "\lib\init\boost.ini"
    , "Stats":A_ScriptDir "\lib\stats.ini"}

CreateInit(Replace := 1) {
    if (!FileExist("lib\init"))
        FileCreateDir, lib\init
    if (Replace)
        for ini in AllVars
            CreateIni(ini)
    else
        for ini in AllVars
            UpdateIni(ini)
    SuccessfullyUpdated := 0
}

CreateIni(Path := "Config") {
    Global
    Local Header, Pair, Name, Value, ini
    for Header, Pair in AllVars[Path]
    {
        ini .= "[" Header "]`r`n"
        for Name, Value in Pair
        {
            %Name% := Value
            ini .= Name "=" Value "`r`n"
        }
        ini .= "`r`n"
    }
    
    FileDelete, % IniPaths[Path]
    FileAppend, % ini, % IniPaths[Path]
}

UpdateIni(Path := "Config") {
    Local Header, Pair, Name, ini
    
    for Header, Pair in AllVars[Path]
    {
        ini .= "[" Header "]`r`n"
        for Name in Pair
            ini .= Name "=" %Name% "`r`n"
        ini .= "`r`n"
    }
    
    FileDelete, % IniPaths[Path]
    FileAppend, % ini, % IniPaths[Path]
}

ReadFromAllInis() {
    for ini, path in IniPaths
        ReadFromIni(path)
}

ReadFromIni(path := "lib\init\config.ini") {
    Global
    Local ini, content, ind, varname
    ini := FileOpen(path, "r"), content := ini.Read(), ini.Close()
    Loop, Parse, content, `r`n, %A_Space%%A_Tab%
    {
        Switch (SubStr(A_LoopField, 1, 1))
        {
        Case "[", ";":
            Continue
        
        Default:
            if (ind := InStr(A_LoopField, "="))
                varname := SubStr(A_LoopField, 1, ind - 1), %varname% := SubStr(A_LoopField, ind + 1)
        }
    }
}

GuiToAllInis() {
    for i, path in IniPaths
        GuiToIni(path)
}

GuiToIni(path := "lib\init\config.ini") {
    Global
    Local ini, content, ind, varname, header, guicontent
    ini := FileOpen(path, "r"), content := ini.Read(), ini.Close()
    Loop, Parse, content, `r`n, %A_Space%%A_Tab%
    {
        Switch (SubStr(A_LoopField, 1, 1))
        {
        Case ";":
            Continue
        
        Case "[":
            header := SubStr(A_LoopField, 2, StrLen(A_LoopField) - 2)
        
        Default:
            if (ind := InStr(A_LoopField, "="))
            {
                varname := SubStr(A_LoopField, 1, ind - 1)
                GuiControlGet, guicontent,, %varname%
                if (guicontent != "")
                    IniWrite, %guicontent%, %path%, %header%, %varname%
            }
        }
    }
}

FieldSettingsToIni(path := "lib\init\fields.ini") {
    Global
    GuiControlGet, CurrentlySelectedField
    CurrentlySelectedFieldName := StrSplit(CurrentlySelectedField, " ")[1]
    GuiControlGet, GatherPattern%CurrentlySelectedFieldName%,, GatherPattern
    GuiControlGet, GatherSize%CurrentlySelectedFieldName%,, GatherSize
    GuiControlGet, GatherWidth%CurrentlySelectedFieldName%,, GatherWidth
    GuiControlGet, GatherShiftLockEnabled%CurrentlySelectedFieldName%,, GatherShiftLockEnabled
    GuiControlGet, InvertFB%CurrentlySelectedFieldName%,, InvertFB
    GuiControlGet, InvertRL%CurrentlySelectedFieldName%,, InvertRL
    GuiControlGet, GatherTime%CurrentlySelectedFieldName%,, GatherTime
    GuiControlGet, BagPercent%CurrentlySelectedFieldName%,, BagPercent
    GuiControlGet, GatherStartPosition%CurrentlySelectedFieldName%,, GatherStartPosition
    GuiControlGet, GatherReturnMethod%CurrentlySelectedFieldName%,, GatherReturnMethod
    GuiControlGet, GatherTurn%CurrentlySelectedFieldName%,, GatherTurn
    GuiControlGet, GatherTurnTimes%CurrentlySelectedFieldName%,, GatherTurnTimes
    if (GatherPattern%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherPattern%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherPattern" CurrentlySelectedFieldName
    if (GatherSize%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherSize%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherSize" CurrentlySelectedFieldName
    if (GatherWidth%CurrentlySelectedFieldName%%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherWidth%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherWidth" CurrentlySelectedFieldName
    if (GatherShiftLockEnabled%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherShiftLockEnabled%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherShiftLockEnabled" CurrentlySelectedFieldName
    if (InvertFB%CurrentlySelectedFieldName% != "")
        IniWrite, % InvertFB%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "InvertFB" CurrentlySelectedFieldName
    if (InvertRL%CurrentlySelectedFieldName% != "")
        IniWrite, % InvertRL%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "InvertRL" CurrentlySelectedFieldName
    if (GatherTime%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherTime%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherTime" CurrentlySelectedFieldName
    if (BagPercent%CurrentlySelectedFieldName% != "")
        IniWrite, % BagPercent%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "BagPercent" CurrentlySelectedFieldName
    if (GatherStartPosition%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherStartPosition%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherStartPosition" CurrentlySelectedFieldName
    if (GatherReturnMethod%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherReturnMethod%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherReturnMethod" CurrentlySelectedFieldName
    if (GatherTurn%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherTurn%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherTurn" CurrentlySelectedFieldName
    if (GatherTurnTimes%CurrentlySelectedFieldName% != "")
        IniWrite, % GatherTurnTimes%CurrentlySelectedFieldName%, %path%, %CurrentlySelectedFieldName%, % "GatherTurnTimes" CurrentlySelectedFieldName
    
}