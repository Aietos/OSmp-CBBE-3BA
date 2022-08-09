Scriptname OSmp3BAMCMScript extends SKI_ConfigBase

; OID
int toggleDisableOSmpOID_B
int toggleKeepPlayerSMPOID_B
int toggleKeepNPCSMPOID_B

event OnInit()
	parent.OnInit()

	Modname = "OSmp 3BA"
endEvent


event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	toggleKeepPlayerSMPOID_B = AddToggleOption("Keep SMP in Player Character", OSmp.toggleKeepPlayerSMP)
	toggleKeepNPCSMPOID_B = AddToggleOption("Keep SMP in NPCs who had SMP previously", OSmp.toggleKeepNPCSMP)
	toggleDisableOSmpOID_B = AddToggleOption("Disable OSmp", OSmp.toggleDisableOSmp)
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
	endIf
endEvent

event OnOptionHighlight(int option)
	if (option == toggleDisableOSmpOID_B)
		SetInfoText("Turn on this option to prevent SMP from being applied at OStim scene start.")
	elseif (option == toggleKeepPlayerSMPOID_B)
		SetInfoText("Turn on this option to keep SMP on Player Character even after OStim scene ends.")
	elseif (option == toggleKeepNPCSMPOID_B)
		SetInfoText("Turn on this option to keep SMP on NPCs that had SMP manually applied by you even after OStim scene ends.")
	endif
endEvent

OSmpScript property OSmp auto
