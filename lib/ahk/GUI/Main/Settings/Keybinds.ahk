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
