Scriptname OSmp3BAMCMScript extends SKI_ConfigBase

; OID
int toggleDisableOSmpOID_B
int toggleKeepPlayerSMPOID_B
int toggleKeepNPCSMPOID_B
int toggleAutomaticCupOID_B
int aCupMaximumWeightOID_S
int bCupMaximumWeightOID_S
int cCupMaximumWeightOID_S
int dCupMaximumWeightOID_S



event OnInit()
	parent.OnInit()

	Modname = "OSmp 3BA"
endEvent


event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)

	toggleKeepPlayerSMPOID_B = AddToggleOption("Keep SMP in Player Character", OSmp.toggleKeepPlayerSMP)
	toggleKeepNPCSMPOID_B = AddToggleOption("Keep SMP in NPCs who had SMP previously", OSmp.toggleKeepNPCSMP)
	toggleDisableOSmpOID_B = AddToggleOption("Disable OSmp", OSmp.toggleDisableOSmp)

	SetCursorPosition(1)

	AddHeaderOption("Automatic NPC Cup Size Configuration")
	AddEmptyOption()
	toggleAutomaticCupOID_B = AddToggleOption("Automatic NPC Cup Size", OSmp.toggleAutomaticCup)
	AddEmptyOption()
	aCupMaximumWeightOID_S = AddSliderOption("A Cup Maximum Weight", OSmp.aCupMaximumWeight, "{0}")
	bCupMaximumWeightOID_S = AddSliderOption("B Cup Maximum Weight", OSmp.bCupMaximumWeight, "{0}")
	cCupMaximumWeightOID_S = AddSliderOption("C Cup Maximum Weight", OSmp.cCupMaximumWeight, "{0}")
	dCupMaximumWeightOID_S = AddSliderOption("D Cup Maximum Weight", OSmp.dCupMaximumWeight, "{0}")
	AddEmptyOption()
	AddTextOption("Here you can configure at which weight cups apply", "", OPTION_FLAG_DISABLED)
	AddTextOption("Example:", "", OPTION_FLAG_DISABLED)
	AddTextOption("If A Cup maximum weight is 25", "", OPTION_FLAG_DISABLED)
	AddTextOption("And if B Cup maximum weight is 50", "", OPTION_FLAG_DISABLED)
	AddTextOption("Then, NPCs between 0-25 weight will get A Cup", "", OPTION_FLAG_DISABLED)
	AddTextOption("And NPCs between 26-50 weight will get B Cup", "", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	AddTextOption("To prevent a given Cup size from being applied", "", OPTION_FLAG_DISABLED)
	AddTextOption("set it to -1.", "", OPTION_FLAG_DISABLED)
	AddEmptyOption()
	AddTextOption("Check mod page for more details and examples!", "", OPTION_FLAG_DISABLED)
	AddEmptyOption()
endEvent

event OnOptionSliderOpen(int option)
	if (option == aCupMaximumWeightOID_S)
		SetSliderDialogStartValue(OSmp.aCupMaximumWeight)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(-1.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == bCupMaximumWeightOID_S)
		SetSliderDialogStartValue(OSmp.bCupMaximumWeight)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(-1.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == cCupMaximumWeightOID_S)
		SetSliderDialogStartValue(OSmp.cCupMaximumWeight)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(-1.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseIf (option == dCupMaximumWeightOID_S)
		SetSliderDialogStartValue(OSmp.dCupMaximumWeight)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(-1.0, 100.0)
		SetSliderDialogInterval(1.0)
	endIf
endEvent

event OnOptionSliderAccept(int option, float value)
	if (option == aCupMaximumWeightOID_S)
		OSmp.aCupMaximumWeight = value
		SetSliderOptionValue(aCupMaximumWeightOID_S, OSmp.aCupMaximumWeight, "{0}")
	elseIf (option == bCupMaximumWeightOID_S)
		OSmp.bCupMaximumWeight = value
		SetSliderOptionValue(bCupMaximumWeightOID_S, OSmp.bCupMaximumWeight, "{0}")
	elseIf (option == cCupMaximumWeightOID_S)
		OSmp.cCupMaximumWeight = value
		SetSliderOptionValue(cCupMaximumWeightOID_S, OSmp.cCupMaximumWeight, "{0}")
	elseIf (option == dCupMaximumWeightOID_S)
		OSmp.dCupMaximumWeight = value
		SetSliderOptionValue(dCupMaximumWeightOID_S, OSmp.dCupMaximumWeight, "{0}")
	endIf
endEvent

event OnOptionSelect(int option)
	if (option == toggleDisableOSmpOID_B)
		OSmp.toggleDisableOSmp = !OSmp.toggleDisableOSmp
		SetToggleOptionValue(toggleDisableOSmpOID_B, OSmp.toggleDisableOSmp)
	elseif (option == toggleKeepPlayerSMPOID_B)
		OSmp.toggleKeepPlayerSMP = !OSmp.toggleKeepPlayerSMP
		SetToggleOptionValue(toggleKeepPlayerSMPOID_B, OSmp.toggleKeepPlayerSMP)
	elseif (option == toggleKeepNPCSMPOID_B)
		OSmp.toggleKeepNPCSMP = !OSmp.toggleKeepNPCSMP
		SetToggleOptionValue(toggleKeepNPCSMPOID_B, OSmp.toggleKeepNPCSMP)
	elseif (option == toggleAutomaticCupOID_B)
		OSmp.toggleAutomaticCup = !OSmp.toggleAutomaticCup
		SetToggleOptionValue(toggleAutomaticCupOID_B, OSmp.toggleAutomaticCup)
	endIf
endEvent

event OnOptionHighlight(int option)
	if (option == toggleDisableOSmpOID_B)
		SetInfoText("Turn on this option to prevent SMP from being applied at OStim scene start.")
	elseif (option == toggleKeepPlayerSMPOID_B)
		SetInfoText("Turn on this option to keep SMP on Player Character even after OStim scene ends.")
	elseif (option == toggleKeepNPCSMPOID_B)
		SetInfoText("Turn on this option to keep SMP on NPCs that had SMP manually applied by you even after OStim scene ends.")
	elseif (option == toggleAutomaticCupOID_B)
		SetInfoText("Turn on this option to choose cup size based on the NPC's weight. A Cup is least jiggle, C cup is most jiggle, and D cup the breasts will have a lot of weight and gravity. This does NOT affect breast size!\nThis option works best if your Bodyslide presets vary a lot between 0 and 100 weight.\nYou can configure Cups weight distributions in the options below.")
	endif
endEvent

OSmpScript property OSmp auto
