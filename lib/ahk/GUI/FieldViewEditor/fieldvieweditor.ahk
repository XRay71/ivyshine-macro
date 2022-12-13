GenerateFieldViewEditor() {
    Global CurrentlySelectedField
    Global AllVars
    GuiControlGet, CurrentlySelectedField
    CurrentlySelectedFieldName := StrSplit(CurrentlySelectedField, " ")[1]
    Gui, FieldViewEditor:Destroy
    Gui, FieldViewEditor:+ownerMain +ToolWindow
    if (CurrentlySelectedField && CurrentlySelectedField != "Stump") {
        SquareLength := 10
        LineX := 80
        LineY := 40
        LineW := AllVars["FieldConfig"][CurrentlySelectedFieldName]["FlowersX" CurrentlySelectedFieldName] * SquareLength - SquareLength / 2
        LineH := AllVars["FieldConfig"][CurrentlySelectedFieldName]["FlowersY" CurrentlySelectedFieldName] * SquareLength - Ceil(SquareLength / 2) - 1
        Loop, % AllVars["FieldConfig"][CurrentlySelectedFieldName]["FlowersY" CurrentlySelectedFieldName]
        {
            Gui, FieldViewEditor:Add, Text, x%LineX% y%LineY% w%LineW% 0x10
            LineY += SquareLength
        }
        LineY := 40
        Loop, % AllVars["FieldConfig"][CurrentlySelectedFieldName]["FlowersX" CurrentlySelectedFieldName]
        {
            Gui, FieldViewEditor:Add, Text, x%LineX% y%LineY% h%LineH% 0x1 0x10
            LineX += SquareLength
        }
        
        GuiW := 80 * 2 + LineW - 10
        GuiH := 40 * 2 + LineH - 25
        
        LineX := GuiW - 60
        LineY := GuiH - 5
        LineW += 31
        LineH += 29
        
        if (AllVars["FieldConfig"][CurrentlySelectedFieldName]["NorthWall" CurrentlySelectedFieldName])
            Gui, FieldViewEditor:Add, Text, x63 y25 w%LineW% 0x10
        if (AllVars["FieldConfig"][CurrentlySelectedFieldName]["SouthWall" CurrentlySelectedFieldName])
            Gui, FieldViewEditor:Add, Text, x63 y%LineY% w%LineW% 0x10
        if (AllVars["FieldConfig"][CurrentlySelectedFieldName]["WestWall" CurrentlySelectedFieldName])
            Gui, FieldViewEditor:Add, Text, x63 y25 h%LineH% 0x1 0x10
        if (AllVars["FieldConfig"][CurrentlySelectedFieldName]["EastWall" CurrentlySelectedFieldName])
            Gui, FieldViewEditor:Add, Text, x%LineX% y25 h%LineH% 0x1 0x10
        
        Gui, FieldViewEditor:Add, Text, x6 y10 +BackgroundTrans, North West
        Gui, FieldViewEditor:Add, Text, x0 yp w%GuiW% Center +BackgroundTrans, North
        Gui, FieldViewEditor:Add, Text, xp yp wp-6 Right +BackgroundTrans, North East
        
        GuiH := (40 * 2 + LineH) / 2 - 20
        
        Gui, FieldViewEditor:Add, Text, x6 y%GuiH% w%GuiW% +BackgroundTrans, East
        Gui, FieldViewEditor:Add, Text, x0 yp wp-6 Right +BackgroundTrans, West
        
        GuiH := 40 * 2 + LineH - 55
        
        Gui, FieldViewEditor:Add, Text, x6 y%GuiH% +BackgroundTrans, South West
        Gui, FieldViewEditor:Add, Text, x0 yp w%GuiW% Center +BackgroundTrans, South
        Gui, FieldViewEditor:Add, Text, xp yp wp-6 Right +BackgroundTrans, South East
        
        GuiH := 40 * 2 + LineH - 30
        
        Gui, FieldViewEditor:Show, w%GuiW% h%GuiH%, Field View Editor
        
    } else if (CurrentlySelectedField == "Stump")
        MsgBox, Sorry`, Stump field is currently not implemented!
}