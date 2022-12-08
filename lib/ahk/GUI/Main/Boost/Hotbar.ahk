Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x232 y8 w306 h92, Current Hotbar
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Button, xp-1 yp+6 w40 h40 HwndHotBarSlot1DisplayHWND vHotBarSlot1Display gChangeHotbar, 1
Gui, Main:Add, Button, xp+42 yp wp hp HwndHotBarSlot2DisplayHWND vHotBarSlot2Display gChangeHotbar, 2
Gui, Main:Add, Button, xp+42 yp wp hp HwndHotBarSlot3DisplayHWND vHotBarSlot3Display gChangeHotbar, 3
Gui, Main:Add, Button, xp+42 yp wp hp HwndHotBarSlot4DisplayHWND vHotBarSlot4Display gChangeHotbar, 4
Gui, Main:Add, Button, xp+42 yp wp hp HwndHotBarSlot5DisplayHWND vHotBarSlot5Display gChangeHotbar, 5
Gui, Main:Add, Button, xp+42 yp wp hp HwndHotBarSlot6DisplayHWND vHotBarSlot6Display gChangeHotbar, 6
Gui, Main:Add, Button, xp+42 yp wp hp HwndHotBarSlot7DisplayHWND vHotBarSlot7Display gChangeHotbar, 7

ChangeHotbar(ButtonHWND) {
    CreateEditHotbar(ButtonHWND)
}

Gui, Main:Add, Button, xp-252 yp+42 wp hp-24 Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot1AutoDisplay, auto
Gui, Main:Add, Button, xp+42 yp wp hp Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot2AutoDisplay, auto
Gui, Main:Add, Button, xp+42 yp wp hp Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot3AutoDisplay, auto
Gui, Main:Add, Button, xp+42 yp wp hp Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot4AutoDisplay, auto
Gui, Main:Add, Button, xp+42 yp wp hp Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot5AutoDisplay, auto
Gui, Main:Add, Button, xp+42 yp wp hp Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot6AutoDisplay, auto
Gui, Main:Add, Button, xp+42 yp wp hp Disabled HwndHotBarSlot2AutoDisplayHWND vHotbarSlot7AutoDisplay, auto
