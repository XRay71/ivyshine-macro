#NoEnv
#SingleInstance, Force
#Include %A_ScriptDir%
#Include *i lib\ahk\base.ahk
#UseHook

if (!FileExist("lib\ahk\base.ahk"))
    UnzipFailure()

SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen

;=====================================
; AHK version swapping
;=====================================
RunWith(32)
RunWith(version := 0) {
    if (version == 0) {
        if (!A_IsUnicode || (A_PtrSize != 4 && !A_Is64bitOS) || (A_PtrSize != 8 && A_Is64bitOS)) {
            SplitPath, A_AhkPath,, ahk_directory
            if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe"))
                MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
            else if (A_Is64bitOS)
                Run, "%u64_directory%" "%A_ScriptName%", %A_ScriptDir%
            else
                Run, "%u32_directory%" "%A_ScriptName%", %A_ScriptDir%
        }
        ExitApp
    } else {
        if (A_PtrSize != (version == 32 ? 4 : 8)) {
            SplitPath, A_AhkPath,, ahk_directory
            if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe"))
                MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
            else if (version == 32)
                Run, "%u32_directory%" "%A_ScriptName%", %A_ScriptDir%
            else
                Run, "%u64_directory%" "%A_ScriptName%", %A_ScriptDir%
            ExitApp
        }
    }
}
;=====================================
; Check if zipped
;=====================================
Unzip()
Unzip() {
    psh := ComObjCreate("Shell.Application")
    SplitPath, A_ScriptFullPath,, zip_folder
    SplitPath, zip_folder,,, zip_extension
    downloads_directory := ComObjCreate("Shell.Application").NameSpace("shell:downloads").self.path
    if (zip_extension = "zip") {
        if (FileExist(macro_folder_directory := downloads_directory "\ivyshine_macro"))
            Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
        
        if (ErrorLevel = "ERROR")
            FileRemoveDir, %macro_folder_directory%
        else if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip")) {
            FileCreateDir, %macro_folder_directory%
            psh.Namespace(macro_folder_directory).CopyHere(psh.Namespace(zip_directory).items, 4|16 )
            Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
        } else
            MsgBox, 48, Error, You have not unzipped the folder! Please do so.
        
        if (ErrorLevel = "ERROR") {
            FileRemoveDir, %macro_folder_directory%
            MsgBox, 48, Error, You have not unzipped the folder! Please do so.
        }
        ExitApp
    }
    if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip"))
        FileDelete, %zip_directory%
}
;=====================================
; Check for updates
;=====================================
; CheckForUpdates()
MacroVersion := "001"
SuccessfullyUpdated := 0
CheckForUpdates() {
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    whr.Open("GET", "https://raw.githubusercontent.com/XRay71/ivyshine-macro/main/version.txt", true)
    whr.Send()
    whr.WaitForResponse()
    UpdateVersionCheck := RegExReplace(Trim(whr.ResponseText), "\.? *(\n|\r)+","")
    if (MacroVersion != UpdateVersionCheck) {
        MsgBox, 4, New Version Found!, You are on version v%MacroVersion%. Would you like to install the newest version: v%UpdateVersionCheck%?
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
            } else
                MsgBox, 0x10, Error, Tbh idk how you got here.
            ExitApp
        }
    }
    if (FileExist("version.txt")) {
        FileDelete, version.txt
        SuccessfullyUpdated := 1
        MsgBox, 0, Success!, The macro was updated successfully to version v%MacroVersion%!
    }
}
;=====================================
; Check Resolution
;=====================================
; CheckResolution()
CheckResolution() {
    SysGet, res, Monitor
    if (A_ScreenDPI != 96 || resRight != 1280 || resBottom != 720) {
        scaling := Floor(A_ScreenDPI / 96 * 100)
        MsgBox, 48, Warning!, The images of this macro have been created for 1280x720p resolution on 100`% scaling. You are currently on %resRight%x%resBottom%p with %scaling%`% scaling. Windows display settings will now be opened, please change the resolution accordingly.
        Run, ms-settings:display
        MsgBox, 49, Warning!, Press "OK" when you have changed your resolution to 1280x720p with 100`% scaling. Press "Cancel" to continue regardless.
        IfMsgBox Ok
        Reload
        WinClose, Settings
    }
}
;=====================================
; Initialising
;=====================================
Global AllVars := {}

AllVars["Config"] := {}
AllVars["Config"]["Important"] := {"MoveSpeed":"28"
    , "NumberOfSprinklers":"1"
    , "NumberOfBees":"40"
    , "SlotNumber":"1"
    , "VIPLink":""
    , "MoveMethod":"Glider"}

AllVars["Config"]["Unlocks"] := {"HasRedCannon":"1"
    , "HasParachute":"1"
    , "HasGlider":"1"
    , "HasBearBee":"1"
    , "HasGiftedVicious":"1"}

AllVars["Config"]["Keybinds"] := {"StartHotkey":"F1"
    , "PauseHotkey":"F2"
    , "StopHotkey":"F3"
    , "Layout":"qwerty"
    , "ForwardKey":"w"
    , "BackwardKey":"s"
    , "LeftKey":"a"
    , "RightKey":"d"
    , "CameraRightKey":"."
    , "CameraLeftKey":","
    , "CameraInKey":"i"
    , "CameraOutKey":"o"
    , "CameraUpKey":"PgDn"
    , "CameraDownKey":"PgUp"
    , "KeyDelay":"0"}

AllVars["Config"]["Hotbar"] := {"SprinklerHotbar":"1"
    , "BlueExtractHotbar":"0"
    , "RedExtractHotbar":"0"
    , "MicroConvertorHotbar":"0"
    , "EnzymeHotbar":"0"
    , "OilHotbar":"0"
    , "GlueHotbar":"0"
    , "GumdropsHotbar":"0"
    , "WhirligigHotbar":"0"
    , "StingerHotbar":"0"
    , "DiceHotbar":"0"
    , "GlitterHotbar":"0"}

AllVars["Config"]["GUI"] := {"GuiX":"0"
    , "GuiY":"340"
    , "GuiFollowToggle":"0"
    , "AlwaysOnTop":"0"
    , "CurrentTab":"Settings"}

AllVars["Config"]["rbxfpsunlocker"] := {"Runrbxfpsunlocker":"1"
    , "FPSLevel":"30"}

AllVars["FieldConfig"] := {}
AllVars["FieldConfig"]["Config"] := {"FieldRotationList":"Pine Tree|"
    , "CurrentlySelectedField":"Pine Tree"
    , "NonRotationList":"Bamboo|Blue Flower|Cactus|Clover|Coconut|Dandelion|Mountain Top|Mushroom|Pepper|Pineapple|Pumpkin|Rose|Spider|Strawberry|Stump|Sunflower|"
    , "DoGather":"1"}
AllVars["Stats"] := {}

FieldDefaults := {}
FieldDefaults["Bamboo"] := {"FlowersX":"39", "FlowersY":"18", "NorthWall":"1", "EastWall":"0", "WestWall":"0", "SouthWall":"0"}
FieldDefaults["Blue Flower"] := {"FlowersX":"43", "FlowersY":"17", "NorthWall":"1", "EastWall":"0", "WestWall":"0", "SouthWall":"1"}
FieldDefaults["Cactus"] := {"FlowersX":"33", "FlowersY":"18", "NorthWall":"0", "EastWall":"1", "WestWall":"0", "SouthWall":"1"}
FieldDefaults["Clover"] := {"FlowersX":"39", "FlowersY":"27", "NorthWall":"0", "EastWall":"0", "WestWall":"0", "SouthWall":"1"}
FieldDefaults["Coconut"] := {"FlowersX":"30", "FlowersY":"21", "NorthWall":"0", "EastWall":"1", "WestWall":"1", "SouthWall":"1"}
FieldDefaults["Dandelion"] := {"FlowersX":"36", "FlowersY":"18", "NorthWall":"0", "EastWall":"0", "WestWall":"0", "SouthWall":"1"}
FieldDefaults["Mountain Top"] := {"FlowersX":"24", "FlowersY":"28", "NorthWall":"0", "EastWall":"0", "WestWall":"0", "SouthWall":"0"}
FieldDefaults["Mushroom"] := {"FlowersX":"32", "FlowersY":"23", "NorthWall":"1", "EastWall":"1", "WestWall":"1", "SouthWall":"0"}
FieldDefaults["Pepper"] := {"FlowersX":"21", "FlowersY":"27", "NorthWall":"0", "EastWall":"0", "WestWall":"0", "SouthWall":"0"}
FieldDefaults["Pine Tree"] := {"FlowersX":"23", "FlowersY":"31", "NorthWall":"1", "EastWall":"0", "WestWall":"1", "SouthWall":"0"}
FieldDefaults["Pineapple"] := {"FlowersX":"35", "FlowersY":"23", "NorthWall":"1", "EastWall":"1", "WestWall":"1", "SouthWall":"0"}
FieldDefaults["Pumpkin"] := {"FlowersX":"33", "FlowersY":"17", "NorthWall":"1", "EastWall":"1", "WestWall":"0", "SouthWall":"0"}
FieldDefaults["Rose"] := {"FlowersX":"31", "FlowersY":"20", "NorthWall":"1", "EastWall":"1", "WestWall":"0", "SouthWall":"1"}
FieldDefaults["Spider"] := {"FlowersX":"28", "FlowersY":"25", "NorthWall":"1", "EastWall":"0", "WestWall":"0", "SouthWall":"0"}
FieldDefaults["Strawberry"] := {"FlowersX":"22", "FlowersY":"26", "NorthWall":"1", "EastWall":"0", "WestWall":"1", "SouthWall":"0"}
FieldDefaults["Stump"] := {"NorthWall":"0", "EastWall":"0", "WestWall":"0", "SouthWall":"0"}
FieldDefaults["Sunflower"] := {"FlowersX":"20 ", "FlowersY":"33", "NorthWall":"0", "EastWall":"0", "WestWall":"0", "SouthWall":"0"}

if (FileExist("lib\init"))
    ReadFromAllInis()

CreateInit(!FileExist("lib\init"))
;=====================================
; Check Monitor
;=====================================
CheckMonitor()
CheckMonitor() {
    Global GuiX, GuiY
    loop, %MonitorCount%
    {
        SysGet, CurrentMonitor, MonitorWorkArea, %A_Index%
        if (GuiX < CurrentMonitorLeft || GuiX + 550 > CurrentMonitorRight)
            GuiX := GuiX < CurrentMonitorLeft ? CurrentMonitorLeft : CurrentMonitorRight - 550
        if (GuiY < CurrentMonitorTop || GuiY + 350 > CurrentMonitorBottom)
            GuiY := GuiY < CurrentMonitorTop ? CurrentMonitorTop : CurrentMonitorBottom - 350
    }
}
;=====================================
; Creating GUI
;=====================================
#Include lib\ahk\GUI\gui.ahk
;=====================================
; Run rbxfpsunlocker
; https://github.com/axstin/rbxfpsunlocker
;=====================================
; if (Runrbxfpsunlocker)
; RunFPS(FPSLevel)
GuiClosed() {
    GuiToAllInis()
    WinGetPos, windowX, windowY, windowWidth, windowHeight, Ivyshine Macro
    IniWrite, %windowX%, % IniPaths["Config"], GUI, GuiX
    IniWrite, %windowY%, % IniPaths["Config"], GUI, GuiY
}

StartMacro() {
    MsgBox, Start
    Return
}

PauseMacro() {
    MsgBox, Pause
    Return
}

StopMacro() {
    MsgBox, Stop
    Return
}

MainGuiClose() {
    GuiClosed()
    ExitApp
}

EditHotkeysGuiClose() {
    Global StartHotkey
    Global PauseHotkey
    Global StopHotkey
    
    GuiControl, EditHotkeys:Text, StartHotkeyTemp, %StartHotkey%
    GuiControl, EditHotkeys:Text, PauseHotkeyTemp, %PauseHotkey%
    GuiControl, EditHotkeys:Text, StopHotkeyTemp, %StopHotkey%
    
    Hotkey, %StartHotkey%, StartMacro, On
    Hotkey, %PauseHotkey%, PauseMacro, On
    Hotkey, %StopHotkey%, StopMacro, On
}

UnzipFailure() {
    MsgBox, 48, Error, Some files are missing from the macro! Please download a fresh copy from https://github.com/XRay71/ivyshine-macro.
    ExitApp
}

^r::Reload

^+r::
    FileRemoveDir, lib\init, 1
    FileDelete, lib\stats.ini
    FileDelete, lib\rbxfpsunlocker\settings
