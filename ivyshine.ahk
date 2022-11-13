#NoEnv
#SingleInstance, Force
#Include, %A_ScriptDir%

SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen

MsgBox, 222
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
SplitPath, A_ScriptFullPath,, zip_folder
SplitPath, zip_folder,,, zip_extension
if (zip_extension = "zip") {
    downloads_directory := ComObjCreate("Shell.Application").NameSpace("shell:downloads").self.path
    if (FileExist(macro_folder_directory := downloads_directory "\ivyshine_macro")) {
        Run, "%macro_folder_directory%\ivyshine.ahk"
    }
    else if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip")) {
        FileCreateDir, %macro_folder_directory%
        ComObjCreate("Shell.Application").Namespace(macro_folder_directory).CopyHere(psh.Namespace(zip_directory).items, 4|16 )
        FileCopy, %%, %downloads_directory%
        Run, "%macro_folder_directory%\ivyshine.ahk"
    }
    else {
        MsgBox, 0x10, Error, You have not unzipped the folder! Please do so.
    }
    ExitApp
}
;=====================================
;
;=====================================

;=====================================