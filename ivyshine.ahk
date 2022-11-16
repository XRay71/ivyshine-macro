#NoEnv
#SingleInstance, Force
#Include, %A_ScriptDir%

SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen

;=====================================
; AHK version swapping
;=====================================
if (!A_IsUnicode || (A_PtrSize != 4 && !A_Is64bitOS) || (A_PtrSize != 8 && A_Is64bitOS)) {
    SplitPath, A_AhkPath,, ahk_directory
    if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe")) {
        MsgBox, 0x10, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
    }
    else if (A_Is64bitOS) {
        Run, "%u64_directory%" "%A_ScriptName%", %A_ScriptDir%
    }
    else {
        Run, "%u32_directory%" "%A_ScriptName%", %A_ScriptDir%
    }
    ExitApp
}
;=====================================
; Check if zipped
;=====================================
psh := ComObjCreate("Shell.Application")
SplitPath, A_ScriptFullPath,, zip_folder
SplitPath, zip_folder,,, zip_extension
downloads_directory := ComObjCreate("Shell.Application").NameSpace("shell:downloads").self.path
if (zip_extension = "zip") {
    if (FileExist(macro_folder_directory := downloads_directory "\ivyshine_macro")) {
        Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
    }
    if (ErrorLevel = "ERROR") {
        FileRemoveDir, %macro_folder_directory%
    }
    else if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip")) {
        FileCreateDir, %macro_folder_directory%
        psh.Namespace(macro_folder_directory).CopyHere(psh.Namespace(zip_directory).items, 4|16 )
        Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
    }
    else {
        MsgBox, 0x10, Error, You have not unzipped the folder! Please do so.
    }
    if (ErrorLevel = "ERROR") {
        FileRemoveDir, %macro_folder_directory%
        MsgBox, 0x10, Error, You have not unzipped the folder! Please do so.
    }
    ExitApp
}
if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip")) {
    FileDelete, %zip_directory%
}
;=====================================
; Check for updates (DO LATER)
;=====================================
version := "001"
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/XRay71/ivyshine-macro/main/version.txt", true)
whr.Send()
whr.WaitForResponse()
update_version_check := whr.ResponseText
MsgBox, %update_version_check%
MsgBox, % "002" < %update_version_check%
if (version < update_version_check) {
    MsgBox, 4, New Version Found!, You are on version v%version%. Would you like to install the newest version: v%update_version_check%
    IfMsgBox Yes
    {
        UrlDownloadToFile, *0 https://github.com/XRay71/ivyshine-macro/archive/main.zip, ivyshine_macro_new.zip
        if (ErrorLevel == "1")
            MsgBox, 0x10, Error, There was an error in updating the macro. Nothing has been changed.
        else if (ErrorLevel == "0") {
            FileMove, ivyshine.ahk, ivyshine_old.ahk
            psh.Namespace(A_WorkingDir).CopyHere(psh.Namespace(A_WorkingDir "\ivyshine_macro_new.zip").items, 4|16 )
            FileMove, ivyshine-macro-main\*.*, %A_WorkingDir%, 1
            Loop, %A_WorkingDir%\ivyshine-macro-main\*, D
            {
                FileMoveDir, %A_LoopFileFullPath%, %A_WorkingDir%, 1
            }
            FileRemoveDir, ivyshine-macro-main
            FileDelete, version.txt
            FileDelete, ivyshine_macro_new.zip
            Run, "ivyshine.ahk"
            FileDelete, ivyshine_old.ahk
        }
        else
            MsgBox, 0x10, Error, Tbh idk how you got here.
    }
}
; https://www.autohotkey.com/boards/viewtopic.php?t=57994
;=====================================
