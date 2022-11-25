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
    if (version == 0) {
        if (!A_IsUnicode || (A_PtrSize != 4 && !A_Is64bitOS) || (A_PtrSize != 8 && A_Is64bitOS)) {
            SplitPath, A_AhkPath,, ahk_directory
            if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe")) {
                MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
            } else if (A_Is64bitOS) {
                Run, "%u64_directory%" "%A_ScriptName%", %A_ScriptDir%
            } else {
                Run, "%u32_directory%" "%A_ScriptName%", %A_ScriptDir%
            }
            ExitApp
        }
    } else {
        if (A_PtrSize != (version == 32 ? 4 : 8)) {
            SplitPath, A_AhkPath,, ahk_directory
            if (!FileExist(u32_directory := ahk_directory "\AutoHotkeyU32.exe") || !FileExist(u64_directory := ahk_directory "\AutoHotkeyU64.exe")) {
                MsgBox, 48, Error, Could not find the Unicode versions of AutoHotkey. Please reinstall.
            } else if (version == 32){
                Run, "%u32_directory%" "%A_ScriptName%", %A_ScriptDir%
            } else {
                Run, "%u64_directory%" "%A_ScriptName%", %A_ScriptDir%
            }
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
        if (FileExist(macro_folder_directory := downloads_directory "\ivyshine_macro")) {
            Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
        }
        if (ErrorLevel = "ERROR") {
            FileRemoveDir, %macro_folder_directory%
        } else if (FileExist(zip_directory := downloads_directory "\ivyshine_macro.zip")) {
            FileCreateDir, %macro_folder_directory%
            psh.Namespace(macro_folder_directory).CopyHere(psh.Namespace(zip_directory).items, 4|16 )
            Run, "%macro_folder_directory%\ivyshine.ahk",, UseErrorLevel
        } else {
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
}
;=====================================
; Check for updates
;=====================================
;CheckForUpdates()
CheckForUpdates() {
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
            } else
                MsgBox, 0x10, Error, Tbh idk how you got here.
            ExitApp
        }
    }
    ;if (FileExist("version.txt")) {
    ;FileDelete, version.txt
    ;MsgBox, 0, Success!, The macro was updated successfully to version v%version%!
    ;}
}
;=====================================
; Check Resolution
;=====================================
;CheckResolution()
CheckResolution() {
    SysGet, res, Monitor
    if (A_ScreenDPI != 96 || resRight != 1280 || resBottom != 720) {
        scaling := Floor(A_ScreenDPI / 96 * 100)
        MsgBox, 48, Warning!, The images of this macro have been created for 1280x720p resolution on 100`% scaling. You are currently on %resRight%x%resBottom%p with %scaling%`% scaling. Windows display settings will now be opened, please change the resolution accordingly.
        Run, ms-settings:display
        MsgBox, 49, Warning!, Press "OK" when you have changed your resolution to 1280x720p with 100`% scaling. Press "Cancel" to continue regardless.
        IfMsgBox OK
        Reload
    }
}
;=====================================
; Initialising
;=====================================
CreateInit() {
    if (FileExist("lib\init")) {
        FileRemoveDir, lib\init, 1
    }
    FileCreateDir, lib\init
    CreateConfig()
    CreateFields()
    CreateStats()
}

CreateConfig() {
    if (FileExist("lib\init\config.ini")) {
        FileDelete, lib\init\config.ini
    }
    FileAppend,
    (
        [Important]
        Movespeed=28
        NumberOfSprinklers=1
        NumberOfBees=25
        SlotNumber=1
        VIPLink=
        MoveMethod=Cannon
        [Unlocks]
        HasRedCannon=1
        HasParachute=1
        HasGlider=1
        HasBearBee=1
        HasGiftedVicious=1
        [Keybinds]
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
    if (FileExist("lib\init\fields.ini")) {
        FileDelete, lib\init\fields.ini
    }
    FileAppend,
    (
        [Settings]
        FieldRotationList=Pine Tree|
        CurrentlySelectedField=Pine Tree
        NonRotationList=Bamboo|Blue Flower|Cactus|Clover|Coconut|Dandelion|Mountain Top|Mushroom|Pepper|Pineapple|Pumpkin|Rose|Spider|Strawberry|Stump|Sunflower

    ), lib\init\fields.ini
}

CreateStats() {
    if (FileExist("lib\stats.ini")) {
        FileDelete, lib\stats.ini
    }
    FileAppend,
    (
        [TEMP]
    ), lib\stats.ini

}

if (!FileExist("lib\init\")) {
    CreateInit()
}

ReadFromAllInis()
;=====================================
; Creating GUI
;=====================================
Gui -MaximizeBox
Gui Font, s11 Norm cBlack, Calibri
Gui Add, Tab3, hWndhTab x0 y0 w550 h350 -Wrap +0x8 +Bottom, Settings|Fields|Boost|Mobs|Quests|Planters|Stats

; Tab: Settings
Gui Tab, 1

Gui Add, GroupBox, x8 y8 w150 h175, Basic Config
Gui Add, Text, x14 y27 w138 h2 0x10
Gui Font
Gui Font, s8
Gui Add, Text, x16 y35, Movespeed
Gui Add, Edit, x88 y32 w40 h20 vMovespeed gMovespeedUpdated, %Movespeed%
Gui Add, Text, x16 y59, Move Method
Gui Add, DropDownList, x88 y56 w61 vMoveMethod gGUIUpdated, % MoveMethod != "Cannon" ? StrSplit("Walk|Glider|Cannon", MoveMethod)[1] MoveMethod "|" StrSplit("Walk|Glider|Cannon", MoveMethod)[2] : "Walk|Glider|Cannon||"
Gui Add, Text, x16 y83, # of Sprinklers
Gui Add, DropDownList, x88 y80 w61 vNumberOfSprinklers gGUIUpdated, % NumberOfSprinklers != 6 ? StrSplit("1|2|3|4|5|6", NumberOfSprinklers)[1] NumberOfSprinklers "|" StrSplit("1|2|3|4|5|6", NumberOfSprinklers)[2] : "1|2|3|4|5|6||"
Gui Add, Text, x16 y107, Hiveslot (6-5-4-3-2-1)
Gui Add, DropDownList, x118 y104 w31 vSlotNumber gGUIUpdated, % SlotNumber != 6 ? StrSplit("1|2|3|4|5|6", SlotNumber)[1] SlotNumber "|" StrSplit("1|2|3|4|5|6", SlotNumber)[2] : "1|2|3|4|5|6||"
Gui Add, Text, x16 y132, Private Server Link
Gui Add, Edit, x16 y150 w133 h25 vVIPLink gVIPLinkUpdated, %VIPLink%

Gui Font, s11 Norm cBlack, Calibri
Gui Add, GroupBox, x8 y184 w150 h130, Unlocks
Gui Add, Text, x14 y203 w138 h2 0x10
Gui Font
Gui Font, s8
Gui Add, Text, x16 y210 w69 h20, Red Cannon
Gui Add, CheckBox, x96 y208 w20 h20 vHasRedCannon gGUIUpdated +Checked%HasRedCannon%
Gui Add, Text, x16 y235 w69 h20, Parachute
Gui Add, CheckBox, x96 y232 w20 h20 vHasParachute gGUIUpdated +Checked%HasParachute%
Gui Add, Text, x16 y259 h20, Mountain Glider
Gui Add, CheckBox, x96 y256 w20 h20 vHasGlider gGUIUpdated +Checked%HasGlider%
Gui Add, Text, x16 y283 w69 h20, My hive has
Gui Add, Edit, x88 y280 w30 h20 vNumberOfBees gNumberOfBeesUpdated -VScroll +Number, %NumberOfBees%
Gui Add, Text, x125 y283 w31 h20, bees.

Gui Font, s11 Norm cBlack, Calibri
Gui Add, GroupBox, x168 y8 w117 h75, Bees
Gui Add, Text, x174 y27 w105 h2 0x10
Gui Font
Gui Font, s8
Gui Add, Text, x176 y35 w75 h20, Bear Bee
Gui Add, CheckBox, x256 y32 w20 h20 vHasBearBee gGUIUpdated +Checked%HasBearBee%
Gui Add, Text, x176 y59 w75 h20, Gifted Vicious
Gui Add, CheckBox, x256 y56 w20 h20 vHasGiftedVicious gGUIUpdated +Checked%HasGiftedVicious%

Gui Font, s11 Norm cBlack, Calibri
Gui Add, GroupBox, x424 y8 w117 h266, Keybinds
Gui Add, Text, x430 y27 w105 h2 0x10
Gui Font
Gui Font, s8
Gui Add, DropDownList, x430 y32 w98 vLayout gKeybindsUpdated, % Layout != "custom" ? StrSplit("qwerty|azerty|custom", Layout)[1] Layout "|" StrSplit("qwerty|azerty|custom", Layout)[2] : "qwerty|azerty|custom||"
Gui Add, Text, x430 y59 w79 h20, Move Forward
Gui Add, Text, x430 y107 w75 h20, Move Back
Gui Add, Text, x430 y83 w75 h20, Move Left
Gui Add, Text, x430 y131 w75 h20, Move Right
Gui Add, Text, x430 y155 w75 h20, Camera Left
Gui Add, Text, x430 y179 w75 h20, Camera Right
Gui Add, Text, x430 y203 w75 h20, Zoom In
Gui Add, Text, x430 y227 w75 h20, Zoom Out
Gui Add, Text, x430 y251 w60 h20, Key Delay
if (Layout == "custom") {
    Gui Add, Edit, x512 y56 w20 h20 limit1 vForwardKey gKeybindsUpdated, %ForwardKey%
    Gui Add, Edit, x512 y80 w20 h20 limit1 vLeftKey gKeybindsUpdated, %LeftKey%
    Gui Add, Edit, x512 y104 w20 h20 limit1 vBackwardKey gKeybindsUpdated, %BackwardKey%
    Gui Add, Edit, x512 y128 w20 h20 limit1 vRightKey gKeybindsUpdated, %RightKey%
    Gui Add, Edit, x512 y152 w20 h20 limit1 vCameraLeftKey gKeybindsUpdated, %CameraLeftKey%
    Gui Add, Edit, x512 y176 w20 h20 limit1 vCameraRightKey gKeybindsUpdated, %CameraRightKey%
    Gui Add, Edit, x512 y200 w20 h20 limit1 vCameraInKey gKeybindsUpdated, %CameraInKey%
    Gui Add, Edit, x512 y224 w20 h20 limit1 vCameraOutKey gKeybindsUpdated, %CameraOutKey%
} else {
    Gui Add, Edit, x512 y56 w20 h20 limit1 vForwardKey gKeybindsUpdated +Disabled, %ForwardKey%
    Gui Add, Edit, x512 y80 w20 h20 limit1 vLeftKey gKeybindsUpdated +Disabled, %LeftKey%
    Gui Add, Edit, x512 y104 w20 h20 limit1 vBackwardKey gKeybindsUpdated +Disabled, %BackwardKey%
    Gui Add, Edit, x512 y128 w20 h20 limit1 vRightKey gKeybindsUpdated +Disabled, %RightKey%
    Gui Add, Edit, x512 y152 w20 h20 limit1 vCameraLeftKey gKeybindsUpdated +Disabled, %CameraLeftKey%
    Gui Add, Edit, x512 y176 w20 h20 limit1 vCameraRightKey gKeybindsUpdated +Disabled, %CameraRightKey%
    Gui Add, Edit, x512 y200 w20 h20 limit1 vCameraInKey gKeybindsUpdated +Disabled, %CameraInKey%
    Gui Add, Edit, x512 y224 w20 h20 limit1 vCameraOutKey gKeybindsUpdated +Disabled, %CameraOutKey%
}
Gui Add, Edit, x502 y248 w30 h21 limit3 -VScroll +Number vKeyDelay gGUIUpdated, %KeyDelay%

Gui Add, Button, hWndhBtnRestoreDefaults x424 y280 w116 h34 gResetAllDefaults, Restore Defaults

; Tab: Fields
Gui Tab, 2

Gui Add, DropDownList, x0 y0 vCurrentlySelectedField gFieldSelectionUpdated, % StrSplit(FieldRotationList, CurrentlySelectedField)[1] CurrentlySelectedField "|" StrSplit(FieldRotationList, CurrentlySelectedField)[2]
Gui Add, DropDownList, x100 y0 vAddToRotation, %NonRotationList%
Gui Add, Button, x424 y280 w116 h34 gAddFieldRotation, Add to List

Gui Show, x%GuiX% y%GuiY% w550 h350, Ivyshine Macro

global configpath := "lib\init\config.ini"

MovespeedUpdated() {
    global Movespeed
    GuiControlGet, MovespeedTemp,, Movespeed
    if MovespeedTemp is number
    {
        if (MovespeedTemp > 0 && MovespeedTemp < 42){
            IniWrite, %MovespeedTemp%, %configpath%, Important, Movespeed
            Movespeed := MovespeedTemp
            Return
        }
    }
    GuiControl, Text, Movespeed, %Movespeed%
}

NumberOfBeesUpdated() {
    global NumberOfBees
    GuiControlGet, NumberOfBeesTemp,, NumberOfBees
    if NumberOfBeesTemp is number
    {
        if (NumberOfBeesTemp > 0 && NumberOfBeesTemp < 51){
            IniWrite, %NumberOfBeesTemp%, %configpath%, Important, NumberOfBeesTemp
            NumberOfBees := NumberOfBeesTemp
            Return
        }
    }
    GuiControl, Text, NumberOfBees, %NumberOfBees%
}

VIPLinkUpdated() {
    global VIPLink
    GuiControlGet, VIPLinkTemp,, VIPLink
    if (RegExMatch(VIPLinkTemp, "i)^((http(s)?):\/\/)?((www|web)\.)?roblox\.com\/games\/(1537690962|4189852503)\/?([^\/]*)\?privateServerLinkCode=\d{32}(\&[^\/]*)*$"))
    {
        Trim(VIPLinkTemp)
        IniWrite, %VIPLinkTemp%, %configpath%, Important, VIPLink
        VIPLink := VIPLinkTemp
    } else if (VIPLinkTemp != "") {
        MsgBox, 16, Error, It appears that the link you provided is invalid. Please copy and paste it directly from the private server configuration page.
    }
}

GUIUpdated() {
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
    CurrentlySelectedField := StrReplace(CurrentlySelectedField, A_Space)
    GuiToAllInis()
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
    IniWrite, %windowX%, %configpath%, GUI, GuiX
    IniWrite, %windowY%, %configpath%, GUI, GuiY
}

f1::

GuiEscape:
GuiClose:
    GuiClosed()
ExitApp

^r::Reload