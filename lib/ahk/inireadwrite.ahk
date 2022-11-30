#NoEnv

Global IniPaths := {"Config":A_ScriptDir "\lib\init\config.ini"
    , "FieldConfig":A_ScriptDir "\lib\init\fields.ini"
    , "Stats":A_ScriptDir "\lib\stats.ini"}

CreateInit(Replace := 1){
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