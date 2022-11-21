#NoEnv

ReadFromIni(path := "lib\init\config.ini") {
    Global
    Local inicontent
    FileRead, inicontent, %path%
    if (ErrorLevel == 0) {
        Loop, Parse, inicontent, `n, `r%A_Tab%%A_Space%
        {
            if (SubStr(A_LoopField, 1, 1) == "[" || A_LoopField == "")
            {
            }
            else
            {
                Local temparray := StrSplit(A_LoopField, "=")
                Local varname := temparray[1]
                Local varvalue := temparray[2]
                %varname% := varvalue
            }
        }
    }
}

WriteToIni(path := "lib\init\config.ini") {
    FileRead, inicontent, %path%
    if (ErrorLevel == 0) {
        Loop, Parse, inicontent, `n, `r%A_Tab%%A_Space%
        {
            if (A_LoopField == "")
            {
            }
            else if (SubStr(A_LoopField, 1, 1) == "[")
            {
                sectionname := SubStr(A_LoopField, 2, -1)
            }
            else
            {
                temparray := StrSplit(A_LoopField, "=")
                varname := temparray[1]
                IniWrite, % %varname%, %path%, %sectionname%, %varname%
            }
        }
    }
}

GuiToIni() {
    path := "lib\init\config.ini"
    FileRead, inicontent, %path%
    if (ErrorLevel == 0) {
        Loop, Parse, inicontent, `n, `r%A_Tab%%A_Space%
        {
            if (A_LoopField == "")
            {
            }
            else if (SubStr(A_LoopField, 1, 1) == "[")
            {
                sectionname := SubStr(A_LoopField, 2, -1)
            }
            else
            {
                temparray := StrSplit(A_LoopField, "=")
                varname := temparray[1]
                GuiControlGet, %varname%
                if (%varname% != "")
                    IniWrite, % %varname%, %path%, %sectionname%, %varname%
            }
        }
    }
}