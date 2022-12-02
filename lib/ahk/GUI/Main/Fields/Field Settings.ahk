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