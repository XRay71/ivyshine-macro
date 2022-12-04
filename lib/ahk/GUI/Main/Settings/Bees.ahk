Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x168 y8 w117 h75, Bees
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x176 y35, Bear Bee
Gui, Main:Add, Text, xp yp+24, Gifted Vicious
Gui, Main:Add, CheckBox, x256 y32 w25 vHasBearBee gGuiToAllInis +Checked%HasBearBee%
Gui, Main:Add, CheckBox, xp yp+24 wp vHasGiftedVicious gGuiToAllInis +Checked%HasGiftedVicious%