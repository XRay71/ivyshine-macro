#NoEnv

ReadFromIni()

ReadFromIni(path := "..\init\config.ini") {
    Global
    Local inicontent
    FileRead, inicontent, %path%
    if (ErrorLevel == 0) {
        Loop, Parse, inicontent, `n, `r%A_Tab%%A_Space%
        {
            if (SubStr(A_LoopField, 1, 1) = "[")
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

WriteToIni(path := "..\init\config.ini") {
    FileRead, inicontent, %path%
    if (ErrorLevel == 0) {
        Loop, Parse, inicontent, `n, `r%A_Tab%%A_Space%
        {
            if (SubStr(A_LoopField, 1, 1) = "[")
            {
                sectionname := SubStr(A_LoopField, 2, -1)
                MsgBox, %sectionname%
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