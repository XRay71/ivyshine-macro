#NoEnv
#SingleInstance, Force
#UseHook

SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen

;=====================================
; Check if zipped
;=====================================
Unzip()
Unzip() {
    psh := ComObjCreate("Shell.Application")
    SplitPath, A_ScriptFullPath,, zip_folder
    SplitPath, zip_folder,,, zip_extension
    SplitPath, zip_folder,, zip_folder1
    SplitPath, zip_folder1,,, zip_extension1
    downloads_directory := ComObjCreate("Shell.Application").NameSpace("shell:downloads").self.path
    if (zip_extension == "zip" || zip_extension1 == "zip") {
        if (FileExist(macro_folder_directory := downloads_directory "\ivyshine_macro"))
            Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
        
        if (ErrorLevel == "ERROR")
            FileRemoveDir, %macro_folder_directory%
        else if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip") || FileExist(zip_directory_git := downloads_directory "\ivyshine-macro-main.zip")) {
            FileCreateDir, %macro_folder_directory%
            if (FileExist(zip_directory)) {
                psh.Namespace(macro_folder_directory).CopyHere(psh.Namespace(zip_directory).items, 4|16 )
                Run, "%macro_folder_directory%\ivyshine.ahk", %macro_folder_directory%, UseErrorLevel
            } else {
                psh.Namespace(macro_folder_directory).CopyHere(psh.Namespace(zip_directory_git).items, 4|16 )
                FileMove, %macro_folder_directory%\ivyshine-macro-main\*.*, %macro_folder_directory%, 1
                FileMoveDir, %macro_folder_directory%\ivyshine-macro-main\lib, %macro_folder_directory%, 1
                
                FileRemoveDir, %macro_folder_directory%\ivyshine-macro-main\, 1
                Run, "%macro_folder_directory%\ivyshine.ahk", %macro_folder_directory%, UseErrorLevel
            }
        } else
            MsgBox, 48, Error, You have not unzipped the folder! Please do so.
        
        if (ErrorLevel == "ERROR") {
            FileRemoveDir, %macro_folder_directory%
            MsgBox, 48, Error, You have not unzipped the folder! Please do so.
        }
        ExitApp
    }
    if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip"))
        FileDelete, %zip_directory%
    else if (FileExist(zip_directory_git := downloads_directory "\ivyshine-macro-main.zip"))
        FileDelete, %zip_directory_git%
}
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
                Run, "%u64_directory%" "%A_ScriptName%" /restart, %A_ScriptDir%
            else
                Run, "%u32_directory%" "%A_ScriptName%" /restart, %A_ScriptDir%
        }
        ExitApp
    } else {
        if (A_PtrSize != (version == 32 ? 4 : 8)) {
            SplitPath, A_AhkPath,, ahk_directory
            if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe"))
                MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
            else if (version == 32)
                Run, "%u32_directory%" "%A_ScriptName%" /restart, %A_ScriptDir%
            else
                Run, "%u64_directory%" "%A_ScriptName%" /restart, %A_ScriptDir%
            ExitApp
        }
    }
}
;=====================================
; Check for updates
;=====================================
; CheckForUpdates()
MacroVersion := "001"
CheckForUpdates() {
    psh := ComObjCreate("Shell.Application")
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
                FileMove, ivyshine.ahk, ivyshine_old.ahk
                psh.Namespace(A_WorkingDir).CopyHere(psh.Namespace(A_WorkingDir "\ivyshine_macro_new.zip").items, 4|16 )
                FileMove, ivyshine-macro-main\*.*, %A_WorkingDir%, 1
                FileMoveDir, ivyshine-macro-main\lib, %A_WorkingDir%, 1
                
                FileRemoveDir, ivyshine-macro-main, 1
                FileDelete, ivyshine_macro_new.zip
                Run, "ivyshine.ahk", %A_WorkingDir%
                FileDelete, ivyshine_old.ahk
            } else
                MsgBox, 0x10, Error, Tbh idk how you got here.
            ExitApp
        }
    }
    if (FileExist("version.txt")) {
        FileDelete, version.txt
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
; Start Includes
;=====================================
if (IncludeFailure := (!FileExist("lib\ahk\base.ahk") || !FileExist("lib\ahk\GUI\gui.ahk") || !FileExist("lib\ahk\main\CreateInit.ahk") || !FileExist("lib\ahk\main\SaveGui.ahk")))
    UnzipFailure()
else {
    #Include %A_ScriptDir%
    #Include *i lib\ahk\base.ahk
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
AllVars["FieldConfig"]["Bamboo"] := {"FlowersXBamboo":"39"
    , "FlowersYBamboo":"18"
    , "NorthWallBamboo":"1"
    , "EastWallBamboo":"0"
    , "WestWallBamboo":"0"
    , "SouthWallBamboo":"1"
    , "GatherPatternBamboo":"Pattern"
    , "GatherSizeBamboo":"2"
    , "GatherWidthBamboo":"3"
    , "GatherShiftLockEnabledBamboo":"0"
    , "InvertFBBamboo":"0"
    , "InvertRLBamboo":"0"
    , "GatherTimeBamboo":"20"
    , "BagPercentBamboo":"95"
    , "GatherStartPositionBamboo":"Center"
    , "GatherReturnMethodBamboo":"Reset"
    , "GatherTurnBamboo":"None"
    , "GatherTurnTimesBamboo":"0"}
AllVars["FieldConfig"]["Blue"] := {"FlowersXBlue":"43"
    , "FlowersYBlue":"17"
    , "NorthWallBlue":"1"
    , "EastWallBlue":"0"
    , "WestWallBlue":"0"
    , "SouthWallBlue":"1"
    , "GatherPatternBlue":"Pattern"
    , "GatherSizeBlue":"2"
    , "GatherWidthBlue":"5"
    , "GatherShiftLockEnabledBlue":"0"
    , "InvertFBBlue":"0"
    , "InvertRLBlue":"0"
    , "GatherTimeBlue":"20"
    , "BagPercentBlue":"95"
    , "GatherStartPositionBlue":"Center"
    , "GatherReturnMethodBlue":"Reset"
    , "GatherTurnBlue":"None"
    , "GatherTurnTimesBlue":"0"}
AllVars["FieldConfig"]["Cactus"] := {"FlowersXCactus":"33"
    , "FlowersYCactus":"18"
    , "NorthWallCactus":"0"
    , "EastWallCactus":"1"
    , "WestWallCactus":"0"
    , "SouthWallCactus":"0"
    , "GatherPatternCactus":"Pattern"
    , "GatherSizeCactus":"2"
    , "GatherWidthCactus":"3"
    , "GatherShiftLockEnabledCactus":"0"
    , "InvertFBCactus":"0"
    , "InvertRLCactus":"0"
    , "GatherTimeCactus":"20"
    , "BagPercentCactus":"95"
    , "GatherStartPositionCactus":"Center"
    , "GatherReturnMethodCactus":"Reset"
    , "GatherTurnCactus":"None"
    , "GatherTurnTimesCactus":"0"}
AllVars["FieldConfig"]["Clover"] := {"FlowersXClover":"39"
    , "FlowersYClover":"27"
    , "NorthWallClover":"0"
    , "EastWallClover":"0"
    , "WestWallClover":"0"
    , "SouthWallClover":"1"
    , "GatherPatternClover":"Pattern"
    , "GatherSizeClover":"3"
    , "GatherWidthClover":"3"
    , "GatherShiftLockEnabledClover":"0"
    , "InvertFBClover":"0"
    , "InvertRLClover":"0"
    , "GatherTimeClover":"20"
    , "BagPercentClover":"95"
    , "GatherStartPositionClover":"Center"
    , "GatherReturnMethodClover":"Reset"
    , "GatherTurnClover":"Right"
    , "GatherTurnTimesClover":"4"}
AllVars["FieldConfig"]["Coconut"] := {"FlowersXCoconut":"30"
    , "FlowersYCoconut":"21"
    , "NorthWallCoconut":"0"
    , "EastWallCoconut":"1"
    , "WestWallCoconut":"1"
    , "SouthWallCoconut":"1"
    , "GatherPatternCoconut":"Pattern"
    , "GatherSizeCoconut":"3"
    , "GatherWidthCoconut":"3"
    , "GatherShiftLockEnabledCoconut":"0"
    , "InvertFBCoconut":"0"
    , "InvertRLCoconut":"0"
    , "GatherTimeCoconut":"20"
    , "BagPercentCoconut":"95"
    , "GatherStartPositionCoconut":"South West"
    , "GatherReturnMethodCoconut":"Reset"
    , "GatherTurnCoconut":"Right"
    , "GatherTurnTimesCoconut":"4"}
AllVars["FieldConfig"]["Dandelion"] := {"FlowersXDandelion":"36"
    , "FlowersYDandelion":"18"
    , "NorthWallDandelion":"0"
    , "EastWallDandelion":"0"
    , "WestWallDandelion":"0"
    , "SouthWallDandelion":"1"
    , "GatherPatternDandelion":"Pattern"
    , "GatherSizeDandelion":"2"
    , "GatherWidthDandelion":"3"
    , "GatherShiftLockEnabledDandelion":"0"
    , "InvertFBDandelion":"0"
    , "InvertRLDandelion":"0"
    , "GatherTimeDandelion":"20"
    , "BagPercentDandelion":"95"
    , "GatherStartPositionDandelion":"Center"
    , "GatherReturnMethodDandelion":"Reset"
    , "GatherTurnDandelion":"None"
    , "GatherTurnTimesDandelion":"0"}
AllVars["FieldConfig"]["Mountain"] := {"FlowersXMountain":"24"
    , "FlowersYMountain":"28"
    , "NorthWallMountain":"0"
    , "EastWallMountain":"0"
    , "WestWallMountain":"0"
    , "SouthWallMountain":"0"
    , "GatherPatternMountain":"Pattern"
    , "GatherSizeMountain":"2"
    , "GatherWidthMountain":"2"
    , "GatherShiftLockEnabledMountain":"0"
    , "InvertFBMountain":"0"
    , "InvertRLMountain":"0"
    , "GatherTimeMountain":"20"
    , "BagPercentMountain":"95"
    , "GatherStartPositionMountain":"Center"
    , "GatherReturnMethodMountain":"Reset"
    , "GatherTurnMountain":"Left"
    , "GatherTurnTimesMountain":"2"}
AllVars["FieldConfig"]["Mushroom"] := {"FlowersXMushroom":"32"
    , "FlowersYMushroom":"23"
    , "NorthWallMushroom":"1"
    , "EastWallMushroom":"1"
    , "WestWallMushroom":"1"
    , "SouthWallMushroom":"0"
    , "GatherPatternMushroom":"Pattern"
    , "GatherSizeMushroom":"3"
    , "GatherWidthMushroom":"3"
    , "GatherShiftLockEnabledMushroom":"0"
    , "InvertFBMushroom":"0"
    , "InvertRLMushroom":"0"
    , "GatherTimeMushroom":"20"
    , "BagPercentMushroom":"95"
    , "GatherStartPositionMushroom":"North"
    , "GatherReturnMethodMushroom":"Reset"
    , "GatherTurnMushroom":"None"
    , "GatherTurnTimesMushroom":"0"}
AllVars["FieldConfig"]["Pepper"] := {"FlowersXPepper":"21"
    , "FlowersYPepper":"27"
    , "NorthWallPepper":"0"
    , "EastWallPepper":"0"
    , "WestWallPepper":"0"
    , "SouthWallPepper":"0"
    , "GatherPatternPepper":"Pattern"
    , "GatherSizePepper":"3"
    , "GatherWidthPepper":"3"
    , "GatherShiftLockEnabledPepper":"0"
    , "InvertFBPepper":"0"
    , "InvertRLPepper":"0"
    , "GatherTimePepper":"20"
    , "BagPercentPepper":"95"
    , "GatherStartPositionPepper":"Center"
    , "GatherReturnMethodPepper":"Reset"
    , "GatherTurnPepper":"Left"
    , "GatherTurnTimesPepper":"2"}
AllVars["FieldConfig"]["Pine"] := {"FlowersXPine":"23"
    , "FlowersYPine":"31"
    , "NorthWallPine":"1"
    , "EastWallPine":"0"
    , "WestWallPine":"1"
    , "SouthWallPine":"0"
    , "GatherPatternPine":"Pattern"
    , "GatherSizePine":"3"
    , "GatherWidthPine":"3"
    , "GatherShiftLockEnabledPine":"0"
    , "InvertFBPine":"0"
    , "InvertRLPine":"0"
    , "GatherTimePine":"20"
    , "BagPercentPine":"95"
    , "GatherStartPositionPine":"North West"
    , "GatherReturnMethodPine":"Reset"
    , "GatherTurnPine":"Left"
    , "GatherTurnTimesPine":"2"}
AllVars["FieldConfig"]["Pineapple"] := {"FlowersXPineapple":"35"
    , "FlowersYPineapple":"23"
    , "NorthWallPineapple":"1"
    , "EastWallPineapple":"1"
    , "WestWallPineapple":"1"
    , "SouthWallPineapple":"0"
    , "GatherPatternPineapple":"Pattern"
    , "GatherSizePineapple":"3"
    , "GatherWidthPineapple":"3"
    , "GatherShiftLockEnabledPineapple":"0"
    , "InvertFBPineapple":"0"
    , "InvertRLPineapple":"0"
    , "GatherTimePineapple":"20"
    , "BagPercentPineapple":"95"
    , "GatherStartPositionPineapple":"North"
    , "GatherReturnMethodPineapple":"Reset"
    , "GatherTurnPineapple":"None"
    , "GatherTurnTimesPineapple":"0"}
AllVars["FieldConfig"]["Pumpkin"] := {"FlowersXPumpkin":"33"
    , "FlowersYPumpkin":"17"
    , "NorthWallPumpkin":"1"
    , "EastWallPumpkin":"1"
    , "WestWallPumpkin":"0"
    , "SouthWallPumpkin":"0"
    , "GatherPatternPumpkin":"Pattern"
    , "GatherSizePumpkin":"2"
    , "GatherWidthPumpkin":"3"
    , "GatherShiftLockEnabledPumpkin":"0"
    , "InvertFBPumpkin":"0"
    , "InvertRLPumpkin":"0"
    , "GatherTimePumpkin":"20"
    , "BagPercentPumpkin":"95"
    , "GatherStartPositionPumpkin":"Center"
    , "GatherReturnMethodPumpkin":"Reset"
    , "GatherTurnPumpkin":"None"
    , "GatherTurnTimesPumpkin":"0"}
AllVars["FieldConfig"]["Rose"] := {"FlowersXRose":"31"
    , "FlowersYRose":"20"
    , "NorthWallRose":"1"
    , "EastWallRose":"1"
    , "WestWallRose":"0"
    , "SouthWallRose":"1"
    , "GatherPatternRose":"Pattern"
    , "GatherSizeRose":"2"
    , "GatherWidthRose":"3"
    , "GatherShiftLockEnabledRose":"0"
    , "InvertFBRose":"0"
    , "InvertRLRose":"0"
    , "GatherTimeRose":"20"
    , "BagPercentRose":"95"
    , "GatherStartPositionRose":"North East"
    , "GatherReturnMethodRose":"Reset"
    , "GatherTurnRose":"None"
    , "GatherTurnTimesRose":"0"}
AllVars["FieldConfig"]["Spider"] := {"FlowersXSpider":"28"
    , "FlowersYSpider":"25"
    , "NorthWallSpider":"1"
    , "EastWallSpider":"0"
    , "WestWallSpider":"0"
    , "SouthWallSpider":"0"
    , "GatherPatternSpider":"Pattern"
    , "GatherSizeSpider":"3"
    , "GatherWidthSpider":"3"
    , "GatherShiftLockEnabledSpider":"0"
    , "InvertFBSpider":"0"
    , "InvertRLSpider":"0"
    , "GatherTimeSpider":"20"
    , "BagPercentSpider":"95"
    , "GatherStartPositionSpider":"North"
    , "GatherReturnMethodSpider":"Reset"
    , "GatherTurnSpider":"None"
    , "GatherTurnTimesSpider":"0"}
AllVars["FieldConfig"]["Strawberry"] := {"FlowersXStrawberry":"22"
    , "FlowersYStrawberry":"26"
    , "NorthWallStrawberry":"1"
    , "EastWallStrawberry":"0"
    , "WestWallStrawberry":"1"
    , "SouthWallStrawberry":"0"
    , "GatherPatternStrawberry":"Pattern"
    , "GatherSizeStrawberry":"2"
    , "GatherWidthStrawberry":"3"
    , "GatherShiftLockEnabledStrawberry":"0"
    , "InvertFBStrawberry":"0"
    , "InvertRLStrawberry":"0"
    , "GatherTimeStrawberry":"20"
    , "BagPercentStrawberry":"95"
    , "GatherStartPositionStrawberry":"North West"
    , "GatherReturnMethodStrawberry":"Reset"
    , "GatherTurnStrawberry":"Left"
    , "GatherTurnTimesStrawberry":"1"}
AllVars["FieldConfig"]["Stump"] := {"NorthWallStump":"1"
    , "EastWallStump":"0"
    , "WestWallStump":"0"
    , "SouthWallStump":"0"
    , "GatherPatternStump":"Pattern"
    , "GatherSizeStump":"2"
    , "GatherWidthStump":"2"
    , "GatherShiftLockEnabledStump":"0"
    , "InvertFBStump":"0"
    , "InvertRLStump":"0"
    , "GatherTimeStump":"20"
    , "BagPercentStump":"95"
    , "GatherStartPositionStump":"Center"
    , "GatherReturnMethodStump":"Reset"
    , "GatherTurnStump":"Right"
    , "GatherTurnTimesStump":"2"}
AllVars["FieldConfig"]["Sunflower"] := {"FlowersXSunflower":"20"s
    , "FlowersYSunflower":"33"
    , "NorthWallSunflower":"0"
    , "EastWallSunflower":"0"
    , "WestWallSunflower":"1"
    , "SouthWallSunflower":"0"
    , "GatherPatternSunflower":"Pattern"
    , "GatherSizeSunflower":"2"
    , "GatherWidthSunflower":"3"
    , "GatherShiftLockEnabledSunflower":"0"
    , "InvertFBSunflower":"0"
    , "InvertRLSunflower":"0"
    , "GatherTimeSunflower":"20"
    , "BagPercentSunflower":"95"
    , "GatherStartPositionSunflower":"Center"
    , "GatherReturnMethodSunflower":"Reset"
    , "GatherTurnSunflower":"Left"
    , "GatherTurnTimesSunflower":"2"}
AllVars["BoostConfig"] := {}
AllVars["BoostConfig"]["Config"] := {"BoostRotationList":"Sprinkler|"
    , "CurrentlySelectedBoost":"Sprinkler"
    , "NonBoostRotationList":"Gumdrops|Coconut|Stinger|Microconvertor|Honeysuckle|Whirligig|Field Dice|Jellybeans|Red Extract|Blue Extract|Glitter|Glue|Oil|Enzymes|Tropical Drink|"
    , "DoBoost":"0"}
AllVars["Stats"] := {}

SettingsTurnedOn := FieldsTurnedOn := BoostTurnedOn := MobsTurnedOn := QuestsTurnedOn := PlantersTurnedOn := StatsTurnedOn := 1

if (!IncludeFailure)
    #Include *i lib\ahk\main\CreateInit.ahk
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
if (!IncludeFailure) {
    #Include *i lib\ahk\GUI\gui.ahk
    #Include *i lib\ahk\main\TabSwitches.ahk
}
;=====================================
; Run rbxfpsunlocker
; https://github.com/axstin/rbxfpsunlocker
;=====================================
for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process WHERE name like 'rbxfpsunlocker.exe%' ") {
    OldrbxfpsunlockerDir := process.ExecutablePath
}
if (Runrbxfpsunlocker)
    if (!IncludeFailure) {
        #Include *i lib\ahk\main\RunFPS.ahk
    }

;=====================================
; Functions
;=====================================

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
    Global OldrbxfpsunlockerDir
    GuiClosed()
    Process, Close, rbxfpsunlocker.exe
    if (OldrbxfpsunlockerDir != "")
        Run, "%OldrbxfpsunlockerDir%", % StrReplace(OldrbxfpsunlockerDir, "rbxfpsunlocker.exe"), Hide
    Sleep, 100
    ExitApp
}

GuiClosed() {
    if (!IncludeFailure)
        #Include *i lib\ahk\main\SaveGui.ahk
    WinGetPos, windowX, windowY, windowWidth, windowHeight, Ivyshine Macro
    IniWrite, %windowX%, % IniPaths["Config"], GUI, GuiX
    IniWrite, %windowY%, % IniPaths["Config"], GUI, GuiY
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