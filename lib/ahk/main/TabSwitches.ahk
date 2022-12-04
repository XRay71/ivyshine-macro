SwitchAllTabs(Enable := 2) {
    GuiToAllInis()
    FieldSettingsToIni()
    ReadFromAllInis()
    MasterSwitchTab("Settings", Enable)
    MasterSwitchTab("Fields", Enable)
    MasterSwitchTab("Boost", Enable)
    MasterSwitchTab("Mobs", Enable)
    MasterSwitchTab("Quests", Enable)
    MasterSwitchTab("Planters", Enable)
    MasterSwitchTab("Stats", Enable)
    Gui, FieldViewEditor:Destroy
    Gui, EditHotkeys:Cancel
    Gui, MacroInfo:Cancel
    GuiControlGet, Flag, Main:Enabled, ShowMacroInfoButton
    if (Flag)
        GuiControl, Main:Disable, ShowMacroInfoButton
    else
        GuiControl, Main:Enable, ShowMacroInfoButton
}

MasterSwitchTab(Tab, Enable := 0) {
    if (Enable == 2) {
        if (%Tab%TurnedOn)
            TurnOff%Tab%()
        else
            TurnOn%Tab%()
        %Tab%TurnedOn := !%Tab%TurnedOn
    } else {
        if (Enable)
            TurnOn%Tab%()
        else
            TurnOff%Tab%()
        %Tab%TurnedOn := Enable
    }
}

TurnOffSettings() {
    GuiControl, Main:Disable, Movespeed
    GuiControl, Main:Disable, MoveMethod
    GuiControl, Main:Disable, NumberOfSprinklers
    GuiControl, Main:Disable, SlotNumber
    GuiControl, Main:Disable, VIPLink
    GuiControl, Main:Disable, HasRedCannon
    GuiControl, Main:Disable, HasParachute
    GuiControl, Main:Disable, HasGlider
    GuiControl, Main:Disable, NumberOfBees
    GuiControl, Main:Disable, HasBearBee
    GuiControl, Main:Disable, HasGiftedVicious
    GuiControl, Main:Disable, EditHotkeysButton
    GuiControl, Main:Disable, Layout
    GuiControl, Main:Disable, ForwardKey
    GuiControl, Main:Disable, LeftKey
    GuiControl, Main:Disable, BackwardKey
    GuiControl, Main:Disable, RightKey
    GuiControl, Main:Disable, CameraLeftKey
    GuiControl, Main:Disable, CameraRightKey
    GuiControl, Main:Disable, CameraInKey
    GuiControl, Main:Disable, CameraOutKey
    GuiControl, Main:Disable, KeyDelay
    GuiControl, Main:Disable, Runrbxfpsunlocker
    GuiControl, Main:Disable, FPSLevel
    GuiControl, Main:Disable, SaveFPS
    GuiControl, Main:Disable, SaveFPS
    GuiControl, Main:Disable, RestoreDefaultSettings
}

TurnOnSettings() {
    Global HasParachute
    Global Layout
    Global Runrbxfpsunlocker
    GuiControl, Main:Enable, Movespeed
    GuiControl, Main:Enable, MoveMethod
    GuiControl, Main:Enable, NumberOfSprinklers
    GuiControl, Main:Enable, SlotNumber
    GuiControl, Main:Enable, VIPLink
    GuiControl, Main:Enable, HasRedCannon
    GuiControl, Main:Enable, HasParachute
    if (HasParachute)
        GuiControl, Main:Enable, HasGlider
    GuiControl, Main:Enable, NumberOfBees
    GuiControl, Main:Enable, HasBearBee
    GuiControl, Main:Enable, HasGiftedVicious
    GuiControl, Main:Enable, EditHotkeysButton
    GuiControl, Main:Enable, Layout
    if (Layout == "custom") {
        GuiControl, Main:Enable, ForwardKey
        GuiControl, Main:Enable, LeftKey
        GuiControl, Main:Enable, BackwardKey
        GuiControl, Main:Enable, RightKey
        GuiControl, Main:Enable, CameraLeftKey
        GuiControl, Main:Enable, CameraRightKey
        GuiControl, Main:Enable, CameraInKey
        GuiControl, Main:Enable, CameraOutKey
    }
    GuiControl, Main:Enable, KeyDelay
    GuiControl, Main:Enable, Runrbxfpsunlocker
    if (Runrbxfpsunlocker) {
        GuiControl, Main:Enable, FPSLevel
        GuiControl, Main:Enable, SaveFPS
    }
    GuiControl, Main:Enable, RestoreDefaultSettings
}

TurnOffFields() {
    GuiControl, Main:Disable, CurrentlySelectedField
    GuiControl, Main:Disable, AddToRotation
    GuiControl, Main:Disable, AddFieldRotationButton
    GuiControl, Main:Disable, RemoveFieldRotationButton
    GuiControl, Main:Disable, MoveFieldUpButton
    GuiControl, Main:Disable, MoveFieldDownButton
    GuiControl, Main:Disable, ResetCurrentFieldButton
    GuiControl, Main:Disable, FieldViewbutton
    GuiControl, Main:Disable, GatherPattern
    GuiControl, Main:Disable, GatherSize
    GuiControl, Main:Disable, GatherWidth
    GuiControl, Main:Disable, GatherShiftLockEnabled
    GuiControl, Main:Disable, InvertFB
    GuiControl, Main:Disable, InvertRL
    GuiControl, Main:Disable, GatherTime
    GuiControl, Main:Disable, BagPercent
    GuiControl, Main:Disable, GatherStartPosition
    GuiControl, Main:Disable, GatherReturnMethod
    GuiControl, Main:Disable, GatherTurn
    GuiControl, Main:Disable, GatherTurnTimes
}

TurnOnFields() {
    Global GatherTurn
    GuiControl, Main:Enable, CurrentlySelectedField
    GuiControl, Main:Enable, AddToRotation
    GuiControl, Main:Enable, AddFieldRotationButton
    GuiControl, Main:Enable, RemoveFieldRotationButton
    GuiControl, Main:Enable, MoveFieldUpButton
    GuiControl, Main:Enable, MoveFieldDownButton
    GuiControl, Main:Enable, ResetCurrentFieldButton
    GuiControl, Main:Enable, FieldViewbutton
    GuiControl, Main:Enable, GatherPattern
    GuiControl, Main:Enable, GatherSize
    GuiControl, Main:Enable, GatherWidth
    GuiControl, Main:Enable, GatherShiftLockEnabled
    GuiControl, Main:Enable, InvertFB
    GuiControl, Main:Enable, InvertRL
    GuiControl, Main:Enable, GatherTime
    GuiControl, Main:Enable, BagPercent
    GuiControl, Main:Enable, GatherStartPosition
    GuiControl, Main:Enable, GatherReturnMethod
    GuiControl, Main:Enable, GatherTurn
    if (GatherTurn != "None")
        GuiControl, Main:Enable, GatherTurnTimes
}

TurnOffBoost() {
    
}

TurnOnBoost() {
    
}

TurnOffMobs() {
    
}

TurnOnMobs() {
    
}

TurnOffQuests() {
    
}

TurnOnQuests() {
    
}

TurnOffPlanters() {
    
}

TurnOnPlanters() {
    
}

TurnOffStats() {
    
}

TurnOnStats() {
    
}