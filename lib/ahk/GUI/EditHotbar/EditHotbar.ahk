CreateEditHotbar(ButtonHWND) {
    Global
    Local NumCount, Height, xPos, yPos
    TempButtonHWND := ButtonHWND
    StrReplace(HotbarList, "|",, NumCount)
    Height := NumCount * 13
    if (ButtonHWND == HotBarSlot1DisplayHWND)
        ButtonNum := 1
    else if (ButtonHWND == HotBarSlot2DisplayHWND)
        ButtonNum := 2
    else if (ButtonHWND == HotBarSlot3DisplayHWND)
        ButtonNum := 3
    else if (ButtonHWND == HotBarSlot4DisplayHWND)
        ButtonNum := 4  
    else if (ButtonHWND == HotBarSlot5DisplayHWND)
        ButtonNum := 5
    else if (ButtonHWND == HotBarSlot6DisplayHWND)
        ButtonNum := 6
    else
        ButtonNum := 7
    xPos := GuiX + 217 + (ButtonNum - 1) * 42
    yPos := GuiY + 120
    Gui, EditHotbar:Destroy
    Gui, EditHotbar:+ownerMain +ToolWindow
    HotbarList := StrReplace(HotbarList, "None|")
    Sort, HotbarList, D|
    HotbarList := "None|" HotbarList
    Gui, EditHotbar:Add, ListBox, x0 y0 w80 r%NumCount% vAddToHotbar, %HotbarList%
    Gui, EditHotbar:Add, Button, xp yp%Height% w80 h20 gSaveHotbarSlot, Save
    Height += 20
    Gui, EditHotbar:Show, x%xPos% y%yPos% w80 h%Height%, Slot %ButtonNum%
}

SaveHotbarSlot() {
    Global
    GuiControlGet, AddToHotbar
    if (AddToHotbar == "None" && Hotbar%ButtonNum% != "") {
        HotBarList .= Hotbar%ButtonNum% "|"
        HotbarList := StrReplace(HotbarList, "None|")
        Sort, HotbarList, D|
        HotbarList := "None|" HotbarList
        Hotbar%ButtonNum% := ""
        
    } else if (AddToHotbar != "None") {
        if (Hotbar%ButtonNum% != "")
            HotBarList .= Hotbar%ButtonNum% "|"
        HotbarList := StrReplace(HotbarList, "None|")
        HotbarList := StrReplace(HotbarList, AddToHotbar "|")
        if (Hotbar1 == AddToHotbar)
            Hotbar1 := ""
        else if (Hotbar2 == AddToHotbar)
            Hotbar2 := ""
        else if (Hotbar3 == AddToHotbar)
            Hotbar3 := ""
        else if (Hotbar4 == AddToHotbar)
            Hotbar4 := ""
        else if (Hotbar5 == AddToHotbar)
            Hotbar5 := ""
        else if (Hotbar6 == AddToHotbar)
            Hotbar6 := ""
        else if (Hotbar7 == AddToHotbar)
            Hotbar7 := ""
        Sort, HotbarList, D|
        HotbarList := "None|" HotbarList
        Hotbar%ButtonNum% := AddToHotbar
    }
    
    IniWrite, %HotbarList%, % IniPaths["BoostConfig"], Config, HotbarList
    IniWrite, %Hotbar1%, % IniPaths["BoostConfig"], Config, Hotbar1
    IniWrite, %Hotbar2%, % IniPaths["BoostConfig"], Config, Hotbar2
    IniWrite, %Hotbar3%, % IniPaths["BoostConfig"], Config, Hotbar3
    IniWrite, %Hotbar4%, % IniPaths["BoostConfig"], Config, Hotbar4
    IniWrite, %Hotbar5%, % IniPaths["BoostConfig"], Config, Hotbar5
    IniWrite, %Hotbar6%, % IniPaths["BoostConfig"], Config, Hotbar6
    IniWrite, %Hotbar7%, % IniPaths["BoostConfig"], Config, Hotbar7
    Gui, EditHotbar:Destroy
}