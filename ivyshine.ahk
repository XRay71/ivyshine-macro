#NoEnv
#SingleInstance, Force
#Include %A_ScriptDir%
#Include lib\ahk\base.ahk
#UseHook

SendMode, Input
SetBatchLines, -1
SetTitleMatchMode, 2
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen

;=====================================
; AHK version swapping
;=====================================
; RunWith(32)
RunWith(version := 0) {
    if (version == 0){
        if (!A_IsUnicode || (A_PtrSize != 4 && !A_Is64bitOS) || (A_PtrSize != 8 && A_Is64bitOS)) {
            SplitPath, A_AhkPath,, ahk_directory
            if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe"))
                MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
            else if (A_Is64bitOS)
                Run, "%u64_directory%" "%A_ScriptName%", %A_ScriptDir%
            else
                Run, "%u32_directory%" "%A_ScriptName%", %A_ScriptDir%

            ExitApp
        }
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
;Unzip()
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
;CheckForUpdates()
MacroVersion := "001"
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
CreateInit() {
    if (FileExist("lib\init"))
        FileRemoveDir, lib\init, 1
    FileCreateDir, lib\init
    CreateConfig()
    CreateFields()
    CreateStats()
}

CreateConfig() {
    if (FileExist("lib\init\config.ini"))
        FileDelete, lib\init\config.ini
    FileAppend,
    (
        [Important]
        Movespeed=28
        NumberOfSprinklers=1
        NumberOfBees=40
        SlotNumber=1
        VIPLink=
        MoveMethod=Glider
        [Unlocks]
        HasRedCannon=1
        HasParachute=1
        HasGlider=1
        HasBearBee=1
        HasGiftedVicious=1
        [Keybinds]
        StartHotkey=F1
        PauseHotkey=F2
        StopHotkey=F3
        Layout=qwerty
        ForwardKey=w
        BackwardKey=s
        LeftKey=a
        RightKey=d
        CameraRightKey=.
        CameraLeftKey=,
        CameraInKey=i
        CameraOutKey=o
        CameraUpKey=PgDn
        CameraDownKey=PgUp
        KeyDelay=0
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
        GuiY=340
        GuiFollowToggle=0
        AlwaysOnTop=0
    ), lib\init\config.ini
}

CreateFields() {
    if (FileExist("lib\init\fields.ini"))
        FileDelete, lib\init\fields.ini
    FileAppend,
    (
        [Config]
        FieldRotationList=Pine Tree|
        CurrentlySelectedField=Pine Tree
        NonRotationList=Bamboo|Blue Flower|Cactus|Clover|Coconut|Dandelion|Mountain Top|Mushroom|Pepper|Pineapple|Pumpkin|Rose|Spider|Strawberry|Stump|Sunflower|

    ), lib\init\fields.ini
}

CreateStats() {
    if (FileExist("lib\stats.ini"))
        FileDelete, lib\stats.ini
    FileAppend,
    (
        [TEMP]
    ), lib\stats.ini

}

if (!FileExist("lib\init\"))
    CreateInit()

ReadFromAllInis()
;=====================================
; Creating GUI
;=====================================
Gui, Main:-MaximizeBox
Gui, Main:+Border

if (StrLen(StartHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, x430 y329 w30 h20 vStartHotkeyButtonMain gStartMacro, %StartHotkey%
if (StrLen(PauseHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, x460 y329 w30 h20 vPauseHotkeyButtonMain gPauseMacro, %PauseHotkey%
if (StrLen(StopHotkey) < 5)
    Gui, Main:Font
else
    Gui, Main:Font, s6
Gui, Main:Add, Button, x490 y329 w30 h20 vStopHotkeyButtonMain gStopMacro, %StopHotkey%
Gui, Main:Font
Gui, Main:Add, Text, x525 y335 h20, % "v" MacroVersion

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, Tab3, hWndhTab x0 y0 w550 h350 -Wrap +0x8 +Bottom, Settings|Fields|Boost|Mobs|Quests|Planters|Stats

; Tab: Settings
Gui, Main:Tab, 1

Gui, Main:Add, GroupBox, x8 y8 w150 h175, Basic Config
Gui, Main:Add, Text, x14 y27 w138 h2 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y35, Movespeed
Gui, Main:Add, Edit, x88 y32 w40 h20 vMovespeed gMovespeedUpdated, %Movespeed%
Gui, Main:Add, Text, x16 y59, Move Method
Gui, Main:Add, DropDownList, x88 y56 w61 vMoveMethod gGUIUpdated, % MoveMethod != "Cannon" ? StrSplit("Walk|Glider|Cannon", MoveMethod)[1] MoveMethod "|" StrSplit("Walk|Glider|Cannon", MoveMethod)[2] : "Walk|Glider|Cannon||"
Gui, Main:Add, Text, x16 y83, # of Sprinklers
Gui, Main:Add, DropDownList, x88 y80 w61 vNumberOfSprinklers gGUIUpdated, % NumberOfSprinklers != 6 ? StrSplit("1|2|3|4|5|6", NumberOfSprinklers)[1] NumberOfSprinklers "|" StrSplit("1|2|3|4|5|6", NumberOfSprinklers)[2] : "1|2|3|4|5|6||"
Gui, Main:Add, Text, x16 y107, Hiveslot (6-5-4-3-2-1)
Gui, Main:Add, DropDownList, x118 y104 w31 vSlotNumber gGUIUpdated, % SlotNumber != 6 ? StrSplit("1|2|3|4|5|6", SlotNumber)[1] SlotNumber "|" StrSplit("1|2|3|4|5|6", SlotNumber)[2] : "1|2|3|4|5|6||"
Gui, Main:Add, Text, x16 y132, Private Server Link
Gui, Main:Add, Edit, x16 y150 w133 h25 vVIPLink gVIPLinkUpdated, %VIPLink%

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y184 w150 h130, Unlocks
Gui, Main:Add, Text, x14 y203 w138 h2 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y210 w69 h20, Red Cannon
Gui, Main:Add, CheckBox, x96 y208 w20 h20 vHasRedCannon gGUIUpdated +Checked%HasRedCannon%
Gui, Main:Add, Text, x16 y235 w69 h20, Parachute
Gui, Main:Add, CheckBox, x96 y232 w20 h20 vHasParachute gHasParachuteUpdated +Checked%HasParachute%
Gui, Main:Add, Text, x16 y259 h20, Mountain Glider
Gui, Main:Add, CheckBox, x96 y256 w20 h20 vHasGlider gHasGliderUpdated +Checked%HasGlider%
Gui, Main:Add, Text, x16 y283 w69 h20, My hive has
Gui, Main:Add, Edit, x88 y280 w30 h20 vNumberOfBees gNumberOfBeesUpdated -VScroll +Number, %NumberOfBees%
Gui, Main:Add, Text, x125 y283 w31 h20, bees.

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x168 y8 w117 h75, Bees
Gui, Main:Add, Text, x174 y27 w105 h2 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x176 y35 w75 h20, Bear Bee
Gui, Main:Add, CheckBox, x256 y32 w20 h20 vHasBearBee gGUIUpdated +Checked%HasBearBee%
Gui, Main:Add, Text, x176 y59 w75 h20, Gifted Vicious
Gui, Main:Add, CheckBox, x256 y56 w20 h20 vHasGiftedVicious gGUIUpdated +Checked%HasGiftedVicious%

Hotkey, %StartHotkey%, StartMacro, On
Hotkey, %PauseHotkey%, PauseMacro, On
Hotkey, %StopHotkey%, StopMacro, On

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x296 y8 w117 h125, Hotkeys
Gui, Main:Add, Text, x302 y27 w105 h2 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Button, x302 y35 w101 h20 vStartHotkeyButtonSettings gStartMacro, Start (%StartHotkey%)
Gui, Main:Add, Button, x302 y59 w101 h20 vPauseHotkeyButtonSettings gPauseMacro, Pause (%PauseHotkey%)
Gui, Main:Add, Button, x302 y83 w101 h20 vStopHotkeyButtonSettings gStopMacro, Stop (%StopHotkey%)
Gui, Main:Add, Button, x302 y107 w101 h20 gEditHotkeys, Edit Hotkeys

Gui, EditHotkeys:+ownerMain
Gui, EditHotkeys:+ToolWindow
Gui, EditHotkeys:Add, Text, x4 y7, Start
Gui, EditHotkeys:Add, Hotkey, x40 y4 vStartHotkeyTemp, % StartHotkey == StrReplace(StartHotkey, "#") ? StartHotkey : SubStr(StartHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 y7 vStartWinKey, WinKey
GuiControl, EditHotkeys:, StartWinKey, % StartHotkey != StrReplace(StartHotkey, "#")
Gui, EditHotkeys:Add, Text, x4 y33, Pause
Gui, EditHotkeys:Add, Hotkey, x40 y30 vPauseHotkeyTemp, % PauseHotkey == StrReplace(PauseHotkey, "#") ? PauseHotkey : SubStr(PauseHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 y33 vPauseWinKey, WinKey
GuiControl, EditHotkeys:, PauseWinKey, % PauseHotkey != StrReplace(PauseHotkey, "#")
Gui, EditHotkeys:Add, Text, x4 y59, Stop
Gui, EditHotkeys:Add, Hotkey, x40 y56 vStopHotkeyTemp, % StopHotkey == StrReplace(StopHotkey, "#") ? StopHotkey : SubStr(StopHotkey, 2)
Gui, EditHotkeys:Add, CheckBox, x+5 y59 vStopWinKey, WinKey
GuiControl, EditHotkeys:, StopWinKey, % Stophotkey != StrReplace(Stophotkey, "#")
Gui, EditHotkeys:Add, Button, x10 y85 w215 gSaveEditedHotkeys, Save

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x424 y8 w117 h266, Keybinds
Gui, Main:Add, Text, x430 y27 w105 h2 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, DropDownList, x430 y32 w98 vLayout gKeybindsUpdated, % Layout != "custom" ? StrSplit("qwerty|azerty|custom", Layout)[1] Layout "|" StrSplit("qwerty|azerty|custom", Layout)[2] : "qwerty|azerty|custom||"
Gui, Main:Add, Text, x430 y59 w79 h20, Move Forward
Gui, Main:Add, Text, x430 y107 w75 h20, Move Back
Gui, Main:Add, Text, x430 y83 w75 h20, Move Left
Gui, Main:Add, Text, x430 y131 w75 h20, Move Right
Gui, Main:Add, Text, x430 y155 w75 h20, Camera Left
Gui, Main:Add, Text, x430 y179 w75 h20, Camera Right
Gui, Main:Add, Text, x430 y203 w75 h20, Zoom In
Gui, Main:Add, Text, x430 y227 w75 h20, Zoom Out
Gui, Main:Add, Text, x430 y251 w60 h20, Key Delay
if (Layout == "custom") {
    Gui, Main:Add, Edit, x512 y56 w20 h20 limit1 vForwardKey gKeybindsUpdated, %ForwardKey%
    Gui, Main:Add, Edit, x512 y80 w20 h20 limit1 vLeftKey gKeybindsUpdated, %LeftKey%
    Gui, Main:Add, Edit, x512 y104 w20 h20 limit1 vBackwardKey gKeybindsUpdated, %BackwardKey%
    Gui, Main:Add, Edit, x512 y128 w20 h20 limit1 vRightKey gKeybindsUpdated, %RightKey%
    Gui, Main:Add, Edit, x512 y152 w20 h20 limit1 vCameraLeftKey gKeybindsUpdated, %CameraLeftKey%
    Gui, Main:Add, Edit, x512 y176 w20 h20 limit1 vCameraRightKey gKeybindsUpdated, %CameraRightKey%
    Gui, Main:Add, Edit, x512 y200 w20 h20 limit1 vCameraInKey gKeybindsUpdated, %CameraInKey%
    Gui, Main:Add, Edit, x512 y224 w20 h20 limit1 vCameraOutKey gKeybindsUpdated, %CameraOutKey%
} else {
    Gui, Main:Add, Edit, x512 y56 w20 h20 limit1 vForwardKey gKeybindsUpdated +Disabled, %ForwardKey%
    Gui, Main:Add, Edit, x512 y80 w20 h20 limit1 vLeftKey gKeybindsUpdated +Disabled, %LeftKey%
    Gui, Main:Add, Edit, x512 y104 w20 h20 limit1 vBackwardKey gKeybindsUpdated +Disabled, %BackwardKey%
    Gui, Main:Add, Edit, x512 y128 w20 h20 limit1 vRightKey gKeybindsUpdated +Disabled, %RightKey%
    Gui, Main:Add, Edit, x512 y152 w20 h20 limit1 vCameraLeftKey gKeybindsUpdated +Disabled, %CameraLeftKey%
    Gui, Main:Add, Edit, x512 y176 w20 h20 limit1 vCameraRightKey gKeybindsUpdated +Disabled, %CameraRightKey%
    Gui, Main:Add, Edit, x512 y200 w20 h20 limit1 vCameraInKey gKeybindsUpdated +Disabled, %CameraInKey%
    Gui, Main:Add, Edit, x512 y224 w20 h20 limit1 vCameraOutKey gKeybindsUpdated +Disabled, %CameraOutKey%
}
Gui, Main:Add, Edit, x502 y248 w30 h21 limit3 -VScroll +Number vKeyDelay gGUIUpdated, %KeyDelay%

Gui, Main:Add, Button, hWndhBtnRestoreDefaults x424 y280 w116 h34 gResetAllDefaults, Restore Defaults

; Tab: Fields
Gui, Main:Tab, 2

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y8 w220 h306, GroupBox
Gui, Main:Add, Text, x14 y27 w208 h2 0x10
Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, ListBox, x16 y50 w80 h230 vCurrentlySelectedField gFieldSelectionUpdated, % StrSplit(FieldRotationList, CurrentlySelectedField)[1] CurrentlySelectedField "|" StrSplit(FieldRotationList, CurrentlySelectedField)[2]
Gui, Main:Add, Text, x24 y30 w80 h20 +0x200, Field Rotation
Gui, Main:Add, ListBox, x136 y50 w80 h230 vAddToRotation gAddToRotationUpdated, %NonRotationList%
Gui, Main:Add, Text, x144 y30 w80 h20 +0x200, Non-Rotation
Gui, Main:Add, Button, x104 y120 w24 h23 gAddFieldRotation, <-
Gui, Main:Add, Button, x104 y144 w24 h23 gRemoveFieldRotation, ->
Gui, Main:Add, Button, x104 y176 w24 h23, /\
Gui, Main:Add, Button, x104 y200 w24 h23, \/
Gui, Main:Add, Button, x16 y280 w200 h23, Reset Selected Field to Defaults

Gui, Main:Show, x%GuiX% y%GuiY% w550 h350, Ivyshine Macro

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

    IniWrite, %StartHotkeyTemp%, % IniPaths[1], Keybinds, StartHotkey
    IniWrite, %PauseHotkeyTemp%, % IniPaths[1], Keybinds, PauseHotkey
    IniWrite, %StopHotkeyTemp%, % IniPaths[1], Keybinds, StopHotkey

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

MovespeedUpdated() {
    Global Movespeed
    GuiControlGet, MovespeedTemp,, Movespeed
    if MovespeedTemp is number
        if (MovespeedTemp > 0 && MovespeedTemp < 42){
            IniWrite, %MovespeedTemp%, % IniPaths[1], Important, Movespeed
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
            IniWrite, %NumberOfBeesTemp%, % IniPaths[1], Important, NumberOfBeesTemp
            NumberOfBees := NumberOfBeesTemp
            Return
        }
    GuiControl, Text, NumberOfBees, %NumberOfBees%
}

VIPLinkUpdated() {
    Global VIPLink
    GuiControlGet, VIPLinkTemp,, VIPLink
    if (RegExMatch(VIPLinkTemp, "i)^((http(s)?):\/\/)?((www|web)\.)?roblox\.com\/games\/(1537690962|4189852503)\/?([^\/]*)\?privateServerLinkCode=\d{32}(\&[^\/]*)*$"))
    {
        Trim(VIPLinkTemp)
        IniWrite, %VIPLinkTemp%, % IniPaths[1], Important, VIPLink
        VIPLink := VIPLinkTemp
    } else if (VIPLinkTemp != "")
        MsgBox, 16, Error, It appears that the link you provided is invalid. Please copy and paste it directly from the private server configuration page.
}

GUIUpdated() {
    GuiToAllInis()
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
    ReadFromAllInis()
    Global FieldRotationList
    Global AddToRotation
    Global NonRotationList
    GuiControlGet, AddToRotation
    if (AddToRotation != "") {
        FieldRotationList .= AddToRotation "|"
        CurrentlySelectedField := AddToRotation
        NonRotationList := StrReplace(NonRotationList, AddToRotation "|")

        IniWrite, %FieldRotationList%, % IniPaths[2], Config, FieldRotationList
        IniWrite, %CurrentlySelectedField%, % IniPaths[2], Config, CurrentlySelectedField
        IniWrite, %NonRotationList%, % IniPaths[2], Config, NonRotationList

        GuiControl,, CurrentlySelectedField, % "|" StrSplit(FieldRotationList, CurrentlySelectedField)[1] CurrentlySelectedField "|" StrSplit(FieldRotationList, CurrentlySelectedField)[2]
        GuiControl,, AddToRotation, % "|" NonRotationList
    }
}

RemoveFieldRotation() {
    ReadFromAllInis()
    Global FieldRotationList
    Global NonRotationList
    Global CurrentlySelectedField
    GuiControlGet, CurrentlySelectedField
    if (CurrentlySelectedField != "") {
        NonRotationList := StrReplace(NonRotationList, "||", "|") CurrentlySelectedField
        FieldRotationList := StrReplace(FieldRotationList, CurrentlySelectedField "||")
        CurrentlySelectedField := ""

        IniWrite, %FieldRotationList%, % IniPaths[2], Config, FieldRotationList
        IniWrite, %CurrentlySelectedField%, % IniPaths[2], Config, CurrentlySelectedField
        IniWrite, %NonRotationList%, % IniPaths[2], Config, NonRotationList

        GuiControl,, CurrentlySelectedField, % "|" StrSplit(FieldRotationList, CurrentlySelectedField)[1] CurrentlySelectedField "|" StrSplit(FieldRotationList, CurrentlySelectedField)[2]
        GuiControl,, AddToRotation, % "|" NonRotationList

        ; FieldRotationList .= AddToRotation "|"
        ; CurrentlySelectedField := AddToRotation
        ; NonRotationList := StrReplace(NonRotationList, AddToRotation "|")

        ; IniWrite, %FieldRotationList%, % IniPaths[2], Config, FieldRotationList
        ; IniWrite, %CurrentlySelectedField%, % IniPaths[2], Config, CurrentlySelectedField
        ; IniWrite, %NonRotationList%, % IniPaths[2], Config, NonRotationList

        ; GuiControl,, CurrentlySelectedField, % "|" StrSplit(FieldRotationList, CurrentlySelectedField)[1] CurrentlySelectedField "|" StrSplit(FieldRotationList, CurrentlySelectedField)[2]
        ; GuiControl,, AddToRotation, % "|" NonRotationList
    }
}

ResetAllDefaults() {
    MsgBox, 305, Warning!, This will reset the entire macro to its default settings`, excluding stats.
    IfMsgBox, OK
    {
        CreateConfig()
        CreateFields()
        Reload
    }
}

GuiClosed() {
    GuiToAllInis()
    WinGetPos, windowX, windowY, windowWidth, windowHeight, Ivyshine Macro
    IniWrite, %windowX%, % IniPaths[1], GUI, GuiX
    IniWrite, %windowY%, % IniPaths[1], GUI, GuiY
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

^r::Reload