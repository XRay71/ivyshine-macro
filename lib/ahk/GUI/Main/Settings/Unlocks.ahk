Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x8 y184 w150 h130, Unlocks
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y210, Red Cannon
Gui, Main:Add, CheckBox, x96 yp w25 vHasRedCannon gGuiToAllInis +Checked%HasRedCannon%

Gui, Main:Add, Text, x16 yp+24, Parachute
Gui, Main:Add, CheckBox, x96 yp w25 vHasParachute gHasParachuteUpdated +Checked%HasParachute%

HasParachuteUpdated() {
    Global HasParachute
    GuiControlGet, HasParachute
    if (!HasParachute) {
        HasGlider := 0
        GuiControl,, HasGlider, 0
    }
    GuiToAllInis()
}

Gui, Main:Add, Text, x16 yp+24, Mountain Glider
Gui, Main:Add, CheckBox, x96 yp w25 vHasGlider gHasGliderUpdated +Checked%HasGlider%

HasGliderUpdated() {
    Global HasGlider
    GuiControlGet, HasGlider
    if (HasGlider) {
        HasParachute := 1
        GuiControl,, HasParachute, 1
    }
    GuiToAllInis()
}

Gui, Main:Add, Text, x16 yp+24, My hive has
Gui, Main:Add, Edit, x88 yp-3 w30 vNumberOfBees gNumberOfBeesUpdated -VScroll +Number, %NumberOfBees%
Gui, Main:Add, Text, x125 yp+3, bees.

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