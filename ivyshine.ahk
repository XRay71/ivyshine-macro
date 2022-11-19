#NoEnv
#SingleInstance, Force
#Include %A_ScriptDir%
#Include lib\ahk\base.ahk

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
        MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
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
        MsgBox, 48, Error, You have not unzipped the folder! Please do so.
    }
    if (ErrorLevel = "ERROR") {
        FileRemoveDir, %macro_folder_directory%
        MsgBox, 48, Error, You have not unzipped the folder! Please do so.
    }
    ExitApp
}
if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip")) {
    FileDelete, %zip_directory%
}
;=====================================
; Check for updates
;=====================================
version := "001"
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/XRay71/ivyshine-macro/main/version.txt", true)
whr.Send()
whr.WaitForResponse()
update_version_check := RegExReplace(Trim(whr.ResponseText), "\.? *(\n|\r)+","")
if (version != update_version_check) {
    MsgBox, 4, New Version Found!, You are on version v%version%. Would you like to install the newest version: v%update_version_check%?
    IfMsgBox Yes
    {
        UrlDownloadToFile, *0 https://github.com/XRay71/ivyshine-macro/archive/main.zip, ivyshine_macro_new.zip
        if (ErrorLevel == "1")
            MsgBox, 0x10, Error, There was an error in updating the macro. Nothing has been changed.
        else if (ErrorLevel == "0") {
            psh.Namespace(A_WorkingDir).CopyHere(psh.Namespace(A_WorkingDir "\ivyshine_macro_new.zip").items, 4|16 )
            FileMove, ivyshine.ahk, ivyshine_old.ahk
            FileMove, ivyshine-macro-main\*.*, %A_WorkingDir%, 1
            FileMoveDir, ivyshine-macro-main\lib, %A_WorkingDir%, 1

            FileRemoveDir, ivyshine-macro-main
            FileDelete, ivyshine_macro_new.zip
            Run, "ivyshine.ahk"
            FileDelete, ivyshine_old.ahk
        }
        else
            MsgBox, 0x10, Error, Tbh idk how you got here.
        ExitApp
    }
}
if (FileExist("version.txt")) {
    ;FileDelete, version.txt
    MsgBox, 0, Success!, The macro was updated successfully to version v%version%!
}
;=====================================
; INITIALISING
;=====================================
if (!FileExist("lib\init\config.ini")) {
    FileCreateDir, lib\init
    FileAppend,
    (
        [Important]
        Movespeed=28
        NumberOfSprinkers=1
        NumberOfBees=25
        SlotNumber=1
        VIPLink=
        MoveMethod=Cannon
        ReturnMethod=Reset
        DelayReconnect=60
        [Keybinds]
        Layout=qwerty
        Forward=w
        Backward=s
        Left=a
        Right=d
        Interact=e
        Jump=space
        CameraRight=.
        CameraLeft=,
        CameraIn=i
        CameraOut=o
        CameraUp=PgDn
        CameraDown=PgUp
        [Hotbar]
        SprinklerHotbar=1
        BlueExtractHotbar=0
        RedExtractHotbar=0
        MicroConvertorHotbar=0
        EnzymeHotbar=0
        OilHotbar=0
        GlueHotbar=0
        GumdropsHotbar=0
        WhirligigHotbar=0
        StingerHotbar=0
        DiceHotbar=0
        GlitterHotbar=0
        [GUI]
        GuiX=0
        GuiY=0
        GuiFollowToggle=0
        AlwaysOnTop=0
    ), lib\init\config.ini
}
ReadFromIni()
SysGet, res, Monitor
if (A_ScreenDPI != 96 || resRight != 1280 || resBottom != 720) {
    scaling := Floor(A_ScreenDPI / 96 * 100)
    MsgBox, 48, Warning!, The images of this macro have been created for 1280x720p resolution on 100`% scaling. You are currently on %resRight%x%resBottom%p with %scaling%`% scaling. Windows display settings will now be opened, please change the resolution accordingly.
    Run, ms-settings:display
    MsgBox, 49, Warning!, Press "OK" when you have changed your resolution to 1280x720p with 100`% scaling. Press "Cancel" to continue regardless.
    IfMsgBox OK
    Reload
}

Gui -MaximizeBox
Gui Font, s11 Norm cBlack, Calibri
Gui Add, Tab3, hWndhTab x0 y0 w550 h350 -Wrap +0x8 +Bottom, Settings|Fields|Boost|Mobs|Quests|Planters|Stats
Gui Tab, 1
Gui Font
Gui Font, s8
Gui Add, Edit, x88 y32 w40 h20, 28
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s7
Gui Add, Text, x16 y35 w69 h20, Movespeed
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s7
Gui Add, Text, x16 y59 w69 h20, Move Method
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s7
Gui Add, DropDownList, x88 y56 w61, Walk|Glider||Cannon
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Add, GroupBox, x8 y8 w150 h175, Basic Config
Gui Font
Gui Font, s7
Gui Add, Text, x16 y83 w69 h20, # of Sprinklers
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s7
Gui Add, DropDownList, x88 y80 w61, 0|1||2|3|4
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Add, Text, x16 y27 w138 h2 +0x10
Gui Font
Gui Font, s7
Gui Add, Text, x16 y107 w100 h20, Hiveslot (6-5-4-3-2-1)
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s7
Gui Add, DropDownList, x118 y104 w31, 1||2|3|4|5|6
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s7
Gui Add, Text, x16 y132 w93 h20, Private Server Link
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Font
Gui Font, s8
Gui Add, Edit, x16 y157 w133 h20
Gui Font
Gui Font, s11 Norm cBlack, Calibri
Gui Tab

Gui Show, x2 y339 w550 h350, Ivyshine Macro

GuiEscape:
GuiClose:
ExitApp
