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
;C heckForUpdates()
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
; Run rbxfpsunlocker
; https://github.com/axstin/rbxfpsunlocker
;=====================================
; RunFPS()
RunFPS(FPS := 30) {
    Process, Close, rbxfpsunlocker.exe
    Process, WaitClose, rbxfpsunlocker.exe, 2
    FileDelete, lib\rbxfpsunlocker\settings
    FileAppend,
    (
        UnlockClient=true
        UnlockStudio=false
        FPSCapValues=[%FPS%]
        FPSCapSelection=1
        FPSCap=%FPS%
        CheckForUpdates=false
        NonBlockingErrors=true
        SilentErrors=true
        QuickStart=true
    ), lib\rbxfpsunlocker\settings
    Run, lib\rbxfpsunlocker\rbxfpsunlocker.exe, lib\rbxfpsunlocker
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
OnExit("MainGuiClose")
Gui, Main:-MaximizeBox +Border

if (StrLen(StartHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, x430 y326 w30 vStartHotkeyButtonMain gStartMacro, %StartHotkey%
if (StrLen(PauseHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, xp+30 yp wp vPauseHotkeyButtonMain gPauseMacro, %PauseHotkey%
if (StrLen(StopHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, xp+30 yp wp vStopHotkeyButtonMain gStopMacro, %StopHotkey%

Gui, Main:Font
Gui, Main:Add, Text, x520 y335 w28 Right, % "v" MacroVersion

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, Tab3, hWndhTab x0 y0 w550 h350 vCurrentTab gMainTabUpdated -Wrap +0x8 +Bottom, % StrReplace("Settings|Fields|Boost|Mobs|Quests|Planters|Stats|", CurrentTab, CurrentTab "|")

; Tab: Settings
Gui, Main:Tab, 1

Gui, Main:Add, GroupBox, x8 y8 w150 h175, Basic Config
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y35, Movespeed
Gui, Main:Add, Edit, x88 yp-3 w40 vMovespeed gMovespeedUpdated, %Movespeed%
Gui, Main:Add, Text, x16 yp+27, Move Method
Gui, Main:Add, DropDownList, x88 yp-3 w61 vMoveMethod gGuiToAllInis, % StrReplace("Walk|Glider|Cannon|", MoveMethod, MoveMethod "|")
Gui, Main:Add, Text, x16 yp+27, # of Sprinklers
Gui, Main:Add, DropDownList, x88 yp-3 w61 vNumberOfSprinklers gGuiToAllInis, % StrReplace("1|2|3|4|5|6|", NumberOfSprinklers, NumberOfSprinklers "|")
Gui, Main:Add, Text, x16 yp+27, Hiveslot (6-5-4-3-2-1)
Gui, Main:Add, DropDownList, x118 yp-3 w31 vSlotNumber gGuiToAllInis, % StrReplace("1|2|3|4|5|6|", SlotNumber, SlotNumber "|")
Gui, Main:Add, Text, x16 yp+27, Private Server Link
Gui, Main:Font, s7
Gui, Main:Add, Edit, x16 yp+18 w133 h25 -VScroll vVIPLink gVIPLinkUpdated, %VIPLink%

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y184 w150 h130, Unlocks
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y210, Red Cannon
Gui, Main:Add, CheckBox, x96 yp w25 vHasRedCannon gGuiToAllInis +Checked%HasRedCannon%
Gui, Main:Add, Text, x16 yp+24, Parachute
Gui, Main:Add, CheckBox, x96 yp w25 vHasParachute gHasParachuteUpdated +Checked%HasParachute%
Gui, Main:Add, Text, x16 yp+24, Mountain Glider
Gui, Main:Add, CheckBox, x96 yp w25 vHasGlider gHasGliderUpdated +Checked%HasGlider%
Gui, Main:Add, Text, x16 yp+24, My hive has
Gui, Main:Add, Edit, x88 yp-3 w30 vNumberOfBees gNumberOfBeesUpdated -VScroll +Number, %NumberOfBees%
Gui, Main:Add, Text, x125 yp+3, bees.

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x168 y8 w117 h75, Bees
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x176 y35, Bear Bee
Gui, Main:Add, Text, xp yp+24, Gifted Vicious
Gui, Main:Add, CheckBox, x256 y32 w25 vHasBearBee gGuiToAllInis +Checked%HasBearBee%
Gui, Main:Add, CheckBox, xp yp+24 wpvHasGiftedVicious gGuiToAllInis +Checked%HasGiftedVicious%

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x296 y8 w117 h130, Hotkeys
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Button, xp y35 w101 vStartHotkeyButtonSettings gStartMacro, Start (%StartHotkey%)
Gui, Main:Add, Button, xp yp+24 wp vPauseHotkeyButtonSettings gPauseMacro, Pause (%PauseHotkey%)
Gui, Main:Add, Button, xp yp+24 wp vStopHotkeyButtonSettings gStopMacro, Stop (%StopHotkey%)
Gui, Main:Add, Button, xp yp+24 wp gEditHotkeys, Edit Hotkeys

Gui, EditHotkeys:+ownerMain +ToolWindow
Gui, EditHotkeys:Add, Text, x4 y7, Start
Gui, EditHotkeys:Add, Hotkey, x40 yp-3 vStartHotkeyTemp, % StartHotkey == StrReplace(StartHotkey, "#") ? StartHotkey : SubStr(StartHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 yp+3 vStartWinKey, WinKey
GuiControl, EditHotkeys:, StartWinKey, % StartHotkey != StrReplace(StartHotkey, "#")
Gui, EditHotkeys:Add, Text, x4 yp+24, Pause
Gui, EditHotkeys:Add, Hotkey, x40 yp-3 vPauseHotkeyTemp, % PauseHotkey == StrReplace(PauseHotkey, "#") ? PauseHotkey : SubStr(PauseHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 yp+3 vPauseWinKey, WinKey
GuiControl, EditHotkeys:, PauseWinKey, % PauseHotkey != StrReplace(PauseHotkey, "#")
Gui, EditHotkeys:Add, Text, x4 yp+24, Stop
Gui, EditHotkeys:Add, Hotkey, x40 yp-3 vStopHotkeyTemp, % StopHotkey == StrReplace(StopHotkey, "#") ? StopHotkey : SubStr(StopHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 yp+3 vStopWinKey, WinKey
GuiControl, EditHotkeys:, StopWinKey, % Stophotkey != StrReplace(Stophotkey, "#")
Gui, EditHotkeys:Add, Button, x10 yp+24 w215 gSaveEditedHotkeys, Save

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x424 y8 w117 h268, Keybinds
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, DropDownList, xp y32 wp-4 vLayout gKeybindsUpdated, % StrReplace("qwerty|azerty|custom|", Layout, Layout "|")
Gui, Main:Add, Text, xp yp+27, Move Forward
Gui, Main:Add, Text, xp yp+24, Move Left
Gui, Main:Add, Text, xp yp+24, Move Back
Gui, Main:Add, Text, xp yp+24, Move Right
Gui, Main:Add, Text, xp yp+24, Camera Left
Gui, Main:Add, Text, xp yp+24, Camera Right
Gui, Main:Add, Text, xp yp+24, Zoom In
Gui, Main:Add, Text, xp yp+24, Zoom Out
Gui, Main:Add, Text, xp yp+24 w60, Key Delay
if (Layout == "custom") {
    Gui, Main:Add, Edit, x512 y56 w20 limit1 vForwardKey gKeybindsUpdated, %ForwardKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vLeftKey gKeybindsUpdated, %LeftKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vBackwardKey gKeybindsUpdated, %BackwardKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vRightKey gKeybindsUpdated, %RightKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraLeftKey gKeybindsUpdated, %CameraLeftKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraRightKey gKeybindsUpdated, %CameraRightKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraInKey gKeybindsUpdated, %CameraInKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraOutKey gKeybindsUpdated, %CameraOutKey%
} else {
    Gui, Main:Add, Edit, x512 y56 w20 limit1 vForwardKey gKeybindsUpdated +Disabled, %ForwardKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vLeftKey gKeybindsUpdated +Disabled, %LeftKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vBackwardKey gKeybindsUpdated +Disabled, %BackwardKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vRightKey gKeybindsUpdated +Disabled, %RightKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraLeftKey gKeybindsUpdated +Disabled, %CameraLeftKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraRightKey gKeybindsUpdated +Disabled, %CameraRightKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraInKey gKeybindsUpdated +Disabled, %CameraInKey%
    Gui, Main:Add, Edit, xp yp+24 wp limit1 vCameraOutKey gKeybindsUpdated +Disabled, %CameraOutKey%
}
Gui, Main:Add, Edit, x502 y248 w30 h21 limit3 -VScroll +Number vKeyDelay gGuiToAllInis, %KeyDelay%

Gui, Main:Add, Button, hWndhBtnRestoreDefaults x424 y280 w116 h33 gResetAllDefaults, Restore Defaults

; Tab: Fields
Gui, Main:Tab, 2

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y8 w220 h306, Field Rotation
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y33 w80 Center, Selected
Gui, Main:Add, Text, x136 yp wp Center, Not Selected
Gui, Main:Add, ListBox, x16 y50 wp h230 vCurrentlySelectedField gFieldSelectionUpdated, % StrReplace(FieldRotationList, CurrentlySelectedField, CurrentlySelectedField "|")
Gui, Main:Add, ListBox, x136 yp wp h230 +Sort vAddToRotation gAddToRotationUpdated, %NonRotationList%
Gui, Main:Add, Button, x104 y100 w24 gAddFieldRotation, <-
Gui, Main:Add, Button, xp yp+24 wp gRemoveFieldRotation, ->
Gui, Main:Add, Button, xp y156 wp gMoveFieldRotationUp, /\
Gui, Main:Add, Button, xp yp+24 wp gMoveFieldRotationDown, \/
Gui, Main:Add, Button, x16 y280 w200 h26, Reset Selected Field to Defaults

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x232 y8 w310 h306, Field Settings
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Add, Text, x384 y60 w2 h256 0x1 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Button, x240 y32 w290 -Theme gGenerateFieldViewEditor, Open Field View Editor
Gui, Main:Add, Text, xp y60 w136 Center, Gather Pattern List
Gui, Main:Add, ListBox, xp y80 w136 h230, Pattern
Gui, Main:Add, Text, x392 y60, Pattern Size
Gui, Main:Add, DropDownList, x490 yp-3 w40, 1|2|3||4|5|
Gui, Main:Add, Text, x392 y84, Pattern Width
Gui, Main:Add, DropDownList, x490 yp-3 w40, 1|2|3||4|5|6|7|8|9|10|
Gui, Main:Add, Text, x392 y108, Gather with ShiftLock
Gui, Main:Add, CheckBox, x515 yp w25
Gui, Main:Add, Text, x392 yp+20, Invert Forward/Back
Gui, Main:Add, CheckBox, x515 yp w25
Gui, Main:Add, Text, x392 yp+20, Invert Right/Left
Gui, Main:Add, CheckBox, x515 yp w25
Gui, Main:Add, Text, x392 yp+24, Gather for
Gui, Main:Add, Edit, x+4 yp-3 w30 h20 limit3 -VScroll +Number, 20
Gui, Main:Add, Text, x+4 yp+3, minutes`,
Gui, Main:Add, Text, x392 yp+21, OR until bag is at
Gui, Main:Add, Edit, x+4 yp-3 w20 h20 limit2 -VScroll +Number, 95
Gui, Main:Add, Text, x+4 yp+3, `%
Gui, Main:Add, Text, x392 yp+24, Start in the
Gui, Main:Add, DropDownList, x+4 yp-3 w84, North West|North|North East|West|Center||East|South West|South|South East|
Gui, Main:Add, DropDownList, xp yp+24 wp, Reset||Walk|Rejoin|Whirligig Walk|
Gui, Main:Add, Text, x392 yp+3, Return via
Gui, Main:Add, Text, xp yp+24, Turn the camera
Gui, Main:Add, DropDownList, x+4 yp-3 w57, none||right|left|
Gui, Main:Add, DropDownList, x394 yp+21 w30 h16 +Disabled, 0||1|2|3|
Gui, Main:Add, Text, x+4 yp+3, times before gathering.

Gui, Main:Show, x%GuiX% y%GuiY% w550 h350, Ivyshine Macro

Hotkey, %StartHotkey%, StartMacro, On
Hotkey, %PauseHotkey%, PauseMacro, On
Hotkey, %StopHotkey%, StopMacro, On

MainTabUpdated() {
    Global CurrentTab
    GuiControlGet, CurrentTab
    if (CurrentTab != "Settings")
        Gui, EditHotkeys:Cancel
    else if (CurrentTab != "Fields")
        Gui, FieldViewEditor:Destroy
    GuiToAllInis()
}

EditHotkeys() {
    Gui, EditHotkeys:Show,, Edit Hotkeys
}

SaveEditedHotkeys() {
    Global StartHotkey
    Global PauseHotkey
    Global StopHotkey
    
    Hotkey, %StartHotkey%, Off
    Hotkey, %PauseHotkey%, Off
    Hotkey, %StopHotkey%, Off
    
    GuiControlGet, StartHotkeyTemp
    GuiControlGet, PauseHotkeyTemp
    GuiControlGet, StopHotkeyTemp
    
    GuiControlGet, StartWinKey
    GuiControlGet, PauseWinKey
    GuiControlGet, StopWinKey
    
    if (StartHotkeyTemp == "" || PauseHotkeyTemp == "" || StopHotkeyTemp == ""){
        MsgBox, 4112, Error, Hotkeys cannot be blank!
        Return
    }
    
    if (StartWinKey)
        StartHotkeyTemp := "#" StartHotkeyTemp
    if (PauseWinKey)
        PauseHotkeyTemp := "#" PauseHotkeyTemp
    if (StopWinKey)
        StopHotkeyTemp := "#" StopHotkeyTemp
    
    if (StrLen(StartHotkeyTemp) == 1)
        StartHotkeyTemp := "~" StartHotkeyTemp
    if (StrLen(PauseHotkeyTemp) == 1)
        PauseHotkeyTemp := "~" PauseHotkeyTemp
    if (StrLen(StopHotkeyTemp) == 1)
        StopHotkeyTemp := "~" StopHotkeyTemp
    
    Hotkey, %StartHotkeyTemp%, StartMacro, On
    Hotkey, %PauseHotkeyTemp%, PauseMacro, On
    Hotkey, %StopHotkeyTemp%, StopMacro, On
    
    IniWrite, %StartHotkeyTemp%, % IniPaths["Config"], Keybinds, StartHotkey
    IniWrite, %PauseHotkeyTemp%, % IniPaths["Config"], Keybinds, PauseHotkey
    IniWrite, %StopHotkeyTemp%, % IniPaths["Config"], Keybinds, StopHotkey
    
    if (StrLen(StartHotkeyTemp) < 5)
        Gui, Main:Font
    else
        Gui, Main:Font, s6
    GuiControl, Main:Font, StartHotkeyButtonMain
    
    if (StrLen(PauseHotkeyTemp) < 5)
        Gui, Main:Font
    else
        Gui, Main:Font, s6
    GuiControl, Main:Font, PauseHotkeyButtonMain
    
    if (StrLen(StopHotkeyTemp) < 5)
        Gui, Main:Font
    else
        Gui, Main:Font, s6
    GuiControl, Main:Font, StopHotkeyButtonMain
    
    GuiControl, Main:Text, StartHotkeyButtonMain, %StartHotkeyTemp%
    GuiControl, Main:Text, PauseHotkeyButtonMain, %PauseHotkeyTemp%
    GuiControl, Main:Text, StopHotkeyButtonMain, %StopHotkeyTemp%
    
    GuiControl, Main:Text, StartHotkeyButtonSettings, Start (%StartHotkeyTemp%)
    GuiControl, Main:Text, PauseHotkeyButtonSettings, Pause (%PauseHotkeyTemp%)
    GuiControl, Main:Text, StopHotkeyButtonSettings, Stop (%StopHotkeyTemp%)
    
    StartHotkey := StartHotkeyTemp
    PauseHotkey := PauseHotkeyTemp
    StopHotkey := StopHotkeyTemp
    
    Gui, EditHotkeys:Hide
}

GenerateFieldViewEditor() {
    Global CurrentlySelectedField
    Global FieldDefaults
    GuiControlGet, CurrentlySelectedField
    Gui, FieldViewEditor:Destroy
    Gui, FieldViewEditor:+ownerMain +ToolWindow
    if (CurrentlySelectedField && CurrentlySelectedField != "Stump") {
        SquareLength := 10
        LineX := 80
        LineY := 40
        LineW := FieldDefaults[CurrentlySelectedField]["FlowersX"] * SquareLength - SquareLength / 2
        LineH := FieldDefaults[CurrentlySelectedField]["FlowersY"] * SquareLength - Ceil(SquareLength / 2) - 1
        Loop, % FieldDefaults[CurrentlySelectedField]["FlowersY"]
        {
            Gui, FieldViewEditor:Add, Text, x%LineX% y%LineY% w%LineW% 0x10
            LineY += SquareLength
        }
        LineY := 40
        Loop, % FieldDefaults[CurrentlySelectedField]["FlowersX"]
        {
            Gui, FieldViewEditor:Add, Text, x%LineX% y%LineY% h%LineH% 0x1 0x10
            LineX += SquareLength
        }
        
        GuiW := 80 * 2 + LineW - 10
        GuiH := 40 * 2 + LineH - 25
        
        LineX := GuiW - 60
        LineY := GuiH - 5
        LineW += 31
        LineH += 29
        
        if (FieldDefaults[CurrentlySelectedField]["NorthWall"])
            Gui, FieldViewEditor:Add, Text, x63 y25 w%LineW% 0x10
        if (FieldDefaults[CurrentlySelectedField]["SouthWall"])
            Gui, FieldViewEditor:Add, Text, x63 y%LineY% w%LineW% 0x10
        if (FieldDefaults[CurrentlySelectedField]["WestWall"])
            Gui, FieldViewEditor:Add, Text, x63 y25 h%LineH% 0x1 0x10
        if (FieldDefaults[CurrentlySelectedField]["EastWall"])
            Gui, FieldViewEditor:Add, Text, x%LineX% y25 h%LineH% 0x1 0x10
        
        Gui, FieldViewEditor:Add, Text, x6 y10 +BackgroundTrans, North West
        Gui, FieldViewEditor:Add, Text, x0 yp w%GuiW% Center +BackgroundTrans, North
        Gui, FieldViewEditor:Add, Text, xp yp wp-6 Right +BackgroundTrans, North East
        
        GuiH := (40 * 2 + LineH) / 2 - 20
        
        Gui, FieldViewEditor:Add, Text, x6 y%GuiH% w%GuiW% +BackgroundTrans, East
        Gui, FieldViewEditor:Add, Text, x0 yp wp-6 Right +BackgroundTrans, West
        
        GuiH := 40 * 2 + LineH - 55
        
        Gui, FieldViewEditor:Add, Text, x6 y%GuiH% +BackgroundTrans, South West
        Gui, FieldViewEditor:Add, Text, x0 yp w%GuiW% Center +BackgroundTrans, South
        Gui, FieldViewEditor:Add, Text, xp yp wp-6 Right +BackgroundTrans, South East
        
        GuiH := 40 * 2 + LineH - 30
        
        Gui, FieldViewEditor:Show, w%GuiW% h%GuiH%, Field View Editor
        
    }
}

MovespeedUpdated() {
    Global Movespeed
    GuiControlGet, MovespeedTemp,, Movespeed
    if MovespeedTemp is number
        if (MovespeedTemp > 0 && MovespeedTemp < 42){
            IniWrite, %MovespeedTemp%, % IniPaths["Config"], Important, Movespeed
            Movespeed := MovespeedTemp
            Return
        }
    GuiControl, Text, Movespeed, %Movespeed%
}

NumberOfBeesUpdated() {
    Global NumberOfBees
    GuiControlGet, NumberOfBeesTemp,, NumberOfBees
    if NumberOfBeesTemp is number
        if (NumberOfBeesTemp > 0 && NumberOfBeesTemp < 51){
            IniWrite, %NumberOfBeesTemp%, % IniPaths["Config"], Important, NumberOfBees
            NumberOfBees := NumberOfBeesTemp
            Return
        }
    GuiControl, Text, NumberOfBees, %NumberOfBees%
}

VIPLinkUpdated() {
    Global VIPLink
    GuiControlGet, VIPLinkTemp,, VIPLink
    VIPLinkTemp := Trim(VIPLinkTemp)
    if (VIPLinkTemp == "" || RegExMatch(VIPLinkTemp, "i)^((http(s)?):\/\/)?((www|web)\.)?roblox\.com\/games\/(1537690962|4189852503)\/?([^\/]*)\?privateServerLinkCode=.{32}(\&[^\/]*)*$"))
    {
        IniWrite, %VIPLinkTemp%, % IniPaths["Config"], Important, VIPLink
        VIPLink := VIPLinkTemp
    } else if (VIPLinkTemp != "")
        MsgBox, 16, Error, It appears that the link you provided is invalid. Please copy and paste it directly from the private server configuration page.
}

HasParachuteUpdated() {
    Global HasParachute
    GuiControlGet, HasParachute
    if (!HasParachute) {
        HasGlider := 0
        GuiControl,, HasGlider, 0
    }
    GuiToAllInis()
}

HasGliderUpdated() {
    Global HasGlider
    GuiControlGet, HasGlider
    if (HasGlider) {
        HasParachute := 1
        GuiControl,, HasParachute, 1
    }
    GuiToAllInis()
}

KeybindsUpdated() {
    GuiControlGet, Layout
    if (Layout == "custom") {
        GuiControl, Enable, ForwardKey
        GuiControl, Enable, LeftKey
        GuiControl, Enable, BackwardKey
        GuiControl, Enable, RightKey
        GuiControl, Enable, CameraLeftKey
        GuiControl, Enable, CameraRightKey
        GuiControl, Enable, CameraInKey
        GuiControl, Enable, CameraOutKey
    } else {
        GuiControl, Disable, ForwardKey
        GuiControl, Disable, LeftKey
        GuiControl, Disable, BackwardKey
        GuiControl, Disable, RightKey
        GuiControl, Disable, CameraLeftKey
        GuiControl, Disable, CameraRightKey
        GuiControl, Disable, CameraInKey
        GuiControl, Disable, CameraOutKey
        if (Layout == "qwerty") {
            GuiControl,,ForwardKey, w
            GuiControl,,LeftKey, a
            GuiControl,,BackwardKey, s
            GuiControl,,RightKey, d
            GuiControl,,CameraLeftKey, `,
            GuiControl,,CameraRightKey, `.
            GuiControl,,CameraInKey, i
            GuiControl,,CameraOutKey, o
        } else {
            GuiControl,,ForwardKey, z
            GuiControl,,LeftKey, q
            GuiControl,,BackwardKey, s
            GuiControl,,RightKey, d
            GuiControl,,CameraLeftKey, `.
            GuiControl,,CameraRightKey, `/
            GuiControl,,CameraInKey, i
            GuiControl,,CameraOutKey, o
        }
    }
    GuiToAllInis()
}

FieldSelectionUpdated() {
    Global CurrentlySelectedField
    GuiControlGet, CurrentlySelectedField
    GuiToAllInis()
}

AddToRotationUpdated() {
    Global AddToRotation
    GuiControlGet, AddToRotation
}

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
    }
}

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
    }
}

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

ResetAllDefaults() {
    MsgBox, 305, Warning!, This will reset the entire macro to its default settings`, excluding stats.
    IfMsgBox, OK
    {
        for ini in AllVars
            if (ini != "Stats")
                CreateIni(ini)
        Reload
    }
}

GuiClosed() {
    GuiToAllInis()
    WinGetPos, windowX, windowY, windowWidth, windowHeight, Ivyshine Macro
    IniWrite, %windowX%, % IniPaths["Config"], GUI, GuiX
    IniWrite, %windowY%, % IniPaths["Config"], GUI, GuiY
}

StartMacro() {
    Return
}

PauseMacro() {
    Return
}

StopMacro() {
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
