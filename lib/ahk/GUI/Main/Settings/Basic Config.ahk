Gui, Main:Add, GroupBox, x8 y8 w150 h175, Basic Config
Gui, Main:Add, Text, xp+6 yp+19 wp-12 0x10

Gui, Main:Font
Gui, Main:Font, s8
Gui, Main:Add, Text, x16 y35, Movespeed
Gui, Main:Add, Edit, x88 yp-3 w40 vMovespeed gMovespeedUpdated, %Movespeed%

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

Gui, Main:Add, Text, x16 yp+27, Move Method
Gui, Main:Add, DropDownList, x88 yp-3 w61 vMoveMethod gGuiToAllInis, % StrReplace("Walk|Glider|Cannon|", MoveMethod, MoveMethod "|")

Gui, Main:Add, Text, x16 yp+27, # of Sprinklers
Gui, Main:Add, DropDownList, x88 yp-3 w61 vNumberOfSprinklers gGuiToAllInis, % StrReplace("1|2|3|4|5|6|", NumberOfSprinklers, NumberOfSprinklers "|")

Gui, Main:Add, Text, x16 yp+27, Hiveslot (6-5-4-3-2-1)
Gui, Main:Add, DropDownList, x118 yp-3 w31 vSlotNumber gGuiToAllInis, % StrReplace("1|2|3|4|5|6|", SlotNumber, SlotNumber "|")

Gui, Main:Add, Text, x16 yp+27, Private Server Link
Gui, Main:Font, s7
Gui, Main:Add, Edit, x16 yp+18 w133 h25 -VScroll vVIPLink gVIPLinkUpdated, %VIPLink%

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
