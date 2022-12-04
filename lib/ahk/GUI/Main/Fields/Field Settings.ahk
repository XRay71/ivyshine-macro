CurrentlySelectedFieldName := StrSplit(CurrentlySelectedField, " ")[1]

Gui, Main:Font, s11 Norm cBlack, Calibri
Gui, Main:Add, GroupBox, x232 y8 w310 h306, Field Settings
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10
Gui, Main:Add, Text, x384 y60 w2 h256 0x1 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Button, x240 y32 w290 -Theme vFieldViewButton gGenerateFieldViewEditor, Open Field View Editor

Gui, Main:Add, Text, xp y60 w136 Center, Gather Pattern List
Gui, Main:Add, ListBox, xp y80 w136 h230 vGatherPattern gFieldSettingsUpdated, % StrReplace("Pattern|", GatherPattern%CurrentlySelectedFieldName%, GatherPattern%CurrentlySelectedFieldName% "|")

FieldSettingsUpdated() {
    FieldSettingsToIni()
}

Gui, Main:Add, Text, x392 y60, Pattern Size
Gui, Main:Add, DropDownList, x490 yp-3 w40 vGatherSize gFieldSettingsUpdated, % StrReplace("1|2|3|4|5|", GatherSize%CurrentlySelectedFieldName%, GatherSize%CurrentlySelectedFieldName% "|")

Gui, Main:Add, Text, x392 y84, Pattern Width
Gui, Main:Add, DropDownList, x490 yp-3 w40 vGatherWidth gFieldSettingsUpdated, % StrReplace("1|2|3|4|5|6|7|8|9|10|", GatherWidth%CurrentlySelectedFieldName%, GatherWidth%CurrentlySelectedFieldName% "|")

check := GatherShiftLockEnabled%CurrentlySelectedFieldName%
Gui, Main:Add, Text, x392 y108, Gather with ShiftLock
Gui, Main:Add, CheckBox, x515 yp w25 vGatherShiftLockEnabled gFieldSettingsUpdated +Checked%check%

check := InvertFB%CurrentlySelectedFieldName%
Gui, Main:Add, Text, x392 yp+20, Invert Forward/Back
Gui, Main:Add, CheckBox, x515 yp w25 vInvertFB gFieldSettingsUpdated +Checked%check%

check := InvertRL%CurrentlySelectedFieldName%
Gui, Main:Add, Text, x392 yp+20, Invert Right/Left
Gui, Main:Add, CheckBox, x515 yp w25 vInvertRL gFieldSettingsUpdated +Checked%check%

Gui, Main:Add, Text, x392 yp+24, Gather for
Gui, Main:Add, Edit, x+4 yp-3 w30 h20 limit3 -VScroll +Number vGatherTime gGatherTimeUpdated, % GatherTime%CurrentlySelectedFieldName%
Gui, Main:Add, Text, x+4 yp+3, minutes`,

GatherTimeUpdated() {
    Global GatherTime
    GuiControlGet, GatherTime
    if (!GatherTime && GatherTime != 0) {
        GatherTime := 0
        GuiControl, Main:Text, GatherTime, %GatherTime%
    }
    FieldSettingsToIni()
}

Gui, Main:Add, Text, x392 yp+21, OR until bag is at
Gui, Main:Add, Edit, x+4 yp-3 w25 h20 limit3 -VScroll +Number vBagPercent gBagPercentUpdated, % BagPercent%CurrentlySelectedFieldName%
Gui, Main:Add, Text, x+4 yp+3, `%

BagPercentUpdated() {
    Global BagPercent
    GuiControlGet, BagPercent
    if (!BagPercent || BagPercent < 0) {
        BagPercent := 5
        GuiControl, Main:Text, BagPercent, %BagPercent%
    } else if (BagPercent > 100) {
        BagPercent := 100
        GuiControl, Main:Text, BagPercent, %BagPercent%
    }
    FieldSettingsToIni()
}

Gui, Main:Add, Text, x392 yp+24, Start in the
Gui, Main:Add, DropDownList, x+4 yp-3 w84 vGatherStartPosition gFieldSettingsUpdated, % StrReplace("North West|North|North East|West|Center|East|South West|South|South East|", GatherStartPosition%CurrentlySelectedFieldName%, GatherStartPosition%CurrentlySelectedFieldName% "|")

Gui, Main:Add, DropDownList, xp yp+24 wp vGatherReturnMethod gFieldSettingsUpdated, % StrReplace("Reset|Walk|Rejoin|Whirligig Walk|", GatherReturnMethod%CurrentlySelectedFieldName%, GatherReturnMethod%CurrentlySelectedFieldName% "|")
Gui, Main:Add, Text, x392 yp+3, Return via

Gui, Main:Add, Text, xp yp+24, Turn the camera
Gui, Main:Add, DropDownList, x+4 yp-3 w57 vGatherTurn gGatherTurnUpdated, % StrReplace("None|Right|Left|", GatherTurn%CurrentlySelectedFieldName%, GatherTurn%CurrentlySelectedFieldName% "|")

GatherTurnUpdated() {
    Global GatherTurn
    GuiControlGet, GatherTurn
    if (GatherTurn == "None")
        GuiControl, Main:Disable, GatherTurnTimes
    else
        GuiControl, Main:Enable, GatherTurnTimes
    FieldSettingsToIni()
}

if (GatherTurn == "None")
    Gui, Main:Add, DropDownList, x394 yp+21 w30 +Disabled vGatherTurnTimes gFieldSettingsUpdated, % StrReplace("0|1|2|3|4|", GatherTurnTimes%CurrentlySelectedFieldName%, GatherTurnTimes%CurrentlySelectedFieldName% "|")
else
    Gui, Main:Add, DropDownList, x394 yp+21 w30 vGatherTurnTimes gFieldSettingsUpdated, % StrReplace("0|1|2|3|4|", GatherTurnTimes%CurrentlySelectedFieldName%, GatherTurnTimes%CurrentlySelectedFieldName% "|")
Gui, Main:Add, Text, x+4 yp+3, times before gathering.

FieldSelectionUpdated()