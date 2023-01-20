Scriptname OSmpScript extends Quest

actor DomActor
actor SubActor
actor ThirdActor

bool DomActorIsFemale = false
bool SubActorIsFemale = false
bool ThirdActorIsFemale = false

bool DomActorHadSMP = false
bool SubActorHadSMP = false
bool ThirdActorHadSMP = false

armor SMPslot48
armor SMPslot50
armor SMPslot51
armor SMPslot60

bool property toggleDisableOSmp = false auto
bool property toggleKeepPlayerSMP = true auto
bool property toggleKeepNPCSMP = true auto
bool property toggleAutomaticCup = true auto
float property aCupMaximumWeight = 25.0 auto
float property bCupMaximumWeight = 50.0 auto
float property cCupMaximumWeight = 75.0 auto
float property dCupMaximumWeight = 100.0 auto

Actor property PlayerRef auto

OsexIntegrationMain property OStim auto

mus3baddonmcm property MCM auto
Mus3BPhysicsManager property PM auto


; ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
; ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
; █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
; ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
; ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
; ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝


event OnInit()
	OStim = OUtils.GetOStim()

	registerForModEvent("ostim_prestart", "OstimPreStart")
	registerForModEvent("ostim_start", "OstimStart")
	registerformodevent("ostim_thirdactor_join", "OstimThirdJoin")
	registerformodevent("ostim_thirdactor_leave", "OstimThirdLeave")
	registerformodevent("ostim_end", "OstimEnd")

	PrintToConsole("Installed")
endevent


event OstimPreStart(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM, don't run this event
	if !ostim.isPlayerInvolved() || toggleDisableOSmp
		return
	endif

	PrintToConsole("Starting...")

	DomActor = OStim.GetActor(0)
	SubActor = OStim.GetActor(1)
	ThirdActor = OStim.GetActor(2)

	DomActorHadSMP = isActorSMP(DomActor)
	DomActorIsFemale = OStim.AppearsFemale(DomActor)

	SubActorHadSMP = isActorSMP(SubActor)
	SubActorIsFemale = OStim.AppearsFemale(SubActor)

	if ThirdActor != none
		ThirdActorHadSMP = isActorSMP(ThirdActor)
		ThirdActorIsFemale = OStim.AppearsFemale(ThirdActor)
	endif

	if (DomActorIsFemale && !DomActorHadSMP)
		EquipSmpForActor(DomActor)
	endif

	if (SubActor != none && SubActorIsFemale && !SubActorHadSMP)
		EquipSmpForActor(SubActor)
	endif

	if (ThirdActor != none && ThirdActorIsFemale && !ThirdActorHadSMP)
		EquipSmpForActor(ThirdActor)
	endif

	PrintToConsole("Finished!")
endevent


event OstimThirdJoin(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM or player is not in scene, don't run this event
	; OSmp won't run on NPC scenes
	if !OStim.isPlayerInvolved() || toggleDisableOSmp
		return
	endif

	ThirdActor = OStim.GetActor(2)
	ThirdActorIsFemale = OStim.AppearsFemale(ThirdActor)
	ThirdActorHadSMP = isActorSMP(ThirdActor)

	if (ThirdActorIsFemale && !ThirdActorHadSMP)
		EquipSmpForActor(ThirdActor)
	endif
endevent


event OstimThirdLeave(string eventname, string strarg, float numarg, form sender)
	if (ThirdActorIsFemale && (!toggleKeepNPCSMP || !ThirdActorHadSMP) && isActorSMP(ThirdActor))
		PrintToConsole("Removing SMP from " + ThirdActor.GetActorBase().GetName() + "...")
		MCM.RemoveSMP(ThirdActor)
		PrintToConsole("SMP cleaned from " + ThirdActor.GetActorBase().GetName())
	endif
endevent


event OstimEnd(string eventname, string strarg, float numarg, form sender)
	; if numArg is not -1, it's a scene running on a subthread, and therefore an NPC scene
	if (numarg != -1)
		return
	endif

	PrintToConsole("Checking if any actors need SMP cleaning...")

	if DomActorIsFemale && isActorSMP(DomActor)
		RemoveSmpFromActor(DomActor, DomActorHadSMP)
	endif

	if SubActor && SubActorIsFemale && isActorSMP(SubActor)
		RemoveSmpFromActor(SubActor, SubActorHadSMP)
	endif

	if ThirdActor && ThirdActorIsFemale && isActorSMP(ThirdActor)
		RemoveSmpFromActor(ThirdActor, ThirdActorHadSMP)
	endif
endevent


; ███████╗███╗   ███╗██████╗     ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗
; ██╔════╝████╗ ████║██╔══██╗    ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
; ███████╗██╔████╔██║██████╔╝    █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗
; ╚════██║██║╚██╔╝██║██╔═══╝     ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║
; ███████║██║ ╚═╝ ██║██║         ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║
; ╚══════╝╚═╝     ╚═╝╚═╝         ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝


bool function isPlayerSMP()
	bool isSMP = false

	if PlayerRef.GetItemCount(MCM.SMPONObjectP48) != 0 && MCM.SlotList[MCM.PsTIndex] == MCM.S48
		isSmp = true
	elseIf PlayerRef.GetItemCount(MCM.SMPONObjectP50) != 0 && MCM.SlotList[MCM.PsTIndex] == MCM.S50
		isSmp = true
	elseIf PlayerRef.GetItemCount(MCM.SMPONObjectP51) != 0 && MCM.SlotList[MCM.PsTIndex] == MCM.S51
		isSmp = true
	elseIf PlayerRef.GetItemCount(MCM.SMPONObjectP60) != 0 && MCM.SlotList[MCM.PsTIndex] == MCM.S60
		isSmp = true
	endif

	return isSmp
endfunction


bool function isActorSMP(actor partnerSMP)
	if (partnerSMP == PlayerRef)
		return isPlayerSMP()
	endif

	bool isSMP = false

	String partnerName = partnerSMP.GetActorBase().GetName()

	if (partnerSMP.GetItemCount(MCM.SMPONObjectFA48) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFB48) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFC48) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFD48) != 0) && MCM.SlotList[MCM.NPCsTIndex] == MCM.S48
		isSMP = true
	elseIf (partnerSMP.GetItemCount(MCM.SMPONObjectFA50) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFB50) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFC50) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFD50) != 0) && MCM.SlotList[MCM.NPCsTIndex] == MCM.S50
		isSMP = true
	elseIf (partnerSMP.GetItemCount(MCM.SMPONObjectFA51) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFB51) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFC51) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFD51) != 0) && MCM.SlotList[MCM.NPCsTIndex] == MCM.S51
		isSMP = true
	elseIf (partnerSMP.GetItemCount(MCM.SMPONObjectFA60) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFB60) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFC60) != 0 || partnerSMP.GetItemCount(MCM.SMPONObjectFD60) != 0) && MCM.SlotList[MCM.NPCsTIndex] == MCM.S60
		isSMP = true
	endif

	if isSMP
		PrintToConsole(partnerName + " is in SMP mode")
	else
		PrintToConsole(partnerName + " is in CBPC mode")
	endif

	return isSMP
endfunction


function EquipSmpForPlayer()
	PrintToConsole("Applying SMP to player character ...")

	PM.CBPCPhysicsAccess(PlayerRef, true)

	int PlayerSMPIndex = MCM.PsTIndex

	if MCM.SlotList[PlayerSMPIndex] == MCM.S48
		PlayerRef.EquipItem(MCM.SMPONObjectP48, true, true)
	elseIf MCM.SlotList[PlayerSMPIndex] == MCM.S50
		PlayerRef.EquipItem(MCM.SMPONObjectP50, true, true)
	elseIf MCM.SlotList[PlayerSMPIndex] == MCM.S51
		PlayerRef.EquipItem(MCM.SMPONObjectP51, true, true)
	elseIf MCM.SlotList[PlayerSMPIndex] == MCM.S60
		PlayerRef.EquipItem(MCM.SMPONObjectP60, true, true)
	endIf

	PlayerRef.QueueNiNodeUpdate()

	PrintToConsole("SMP applied to player character")
endfunction


function EquipSmpForActor(Actor act)
	if (act == PlayerRef)
		EquipSmpForPlayer()
		return
	endif

	PrintToConsole("Applying SMP to " + act.GetActorBase().GetName() + "...")

	PM.CBPCPhysicsAccess(act, true)

	int cupSizeToUse = MCM.CupNum

	if toggleAutomaticCup
		float npcWeight = act.GetActorBase().GetWeight()

		cupSizeToUse = 0

		if npcWeight < aCupMaximumWeight
			cupSizeToUse = 0
		elseif npcWeight < bCupMaximumWeight
			cupSizeToUse = 1
		elseif npcWeight < cCupMaximumWeight
			cupSizeToUse = 2
		else
			cupSizeToUse = 3
		endif
	endif

	UpdateNPCSmpArmorForms(cupSizeToUse)

	if MCM.SlotList[MCM.NPCsTIndex] == MCM.S48
		act.EquipItem(SMPslot48 as form, true, true)
	elseIf MCM.SlotList[MCM.NPCsTIndex] == MCM.S50
		act.EquipItem(SMPslot50 as form, true, true)
	elseIf MCM.SlotList[MCM.NPCsTIndex] == MCM.S51
		act.EquipItem(SMPslot51 as form, true, true)
	elseIf MCM.SlotList[MCM.NPCsTIndex] == MCM.S60
		act.EquipItem(SMPslot60 as form, true, true)
	endIf

	act.QueueNiNodeUpdate()

	PrintToConsole("SMP applied to " + act.GetActorBase().GetName() + " with cup size " + cupSizeToUse)
endfunction


function RemoveSmpFromActor(Actor act, bool hadSmp)
	if act == PlayerRef
		if !toggleKeepPlayerSMP
			PrintToConsole("Removing SMP from player character...")
			MCM.RemoveSMP(PlayerRef)
			PrintToConsole("SMP cleaned from player character")
		endif
	else
		if !toggleKeepNPCSMP || !hadSmp
			PrintToConsole("Removing SMP from " + act.GetActorBase().GetName() + "...")
			MCM.RemoveSMP(act)
			PrintToConsole("SMP cleaned from " + act.GetActorBase().GetName())
		endif
	endif
endfunction


; ██╗   ██╗████████╗██╗██╗     ███████╗
; ██║   ██║╚══██╔══╝██║██║     ██╔════╝
; ██║   ██║   ██║   ██║██║     ███████╗
; ██║   ██║   ██║   ██║██║     ╚════██║
; ╚██████╔╝   ██║   ██║███████╗███████║
;  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝


function PrintToConsole(String In)
	MiscUtil.PrintConsole("OSmp: " + In)
endFunction


function UpdateNPCSmpArmorForms(int cupSize)
	if cupSize == 0
		SMPslot48 = MCM.SMPONObjectFA48
		SMPslot50 = MCM.SMPONObjectFA50
		SMPslot51 = MCM.SMPONObjectFA51
		SMPslot60 = MCM.SMPONObjectFA60
	elseIf cupSize == 1
		SMPslot48 = MCM.SMPONObjectFB48
		SMPslot50 = MCM.SMPONObjectFB50
		SMPslot51 = MCM.SMPONObjectFB51
		SMPslot60 = MCM.SMPONObjectFB60
	elseIf cupSize == 2
		SMPslot48 = MCM.SMPONObjectFC48
		SMPslot50 = MCM.SMPONObjectFC50
		SMPslot51 = MCM.SMPONObjectFC51
		SMPslot60 = MCM.SMPONObjectFC60
	elseIf cupSize == 3
		SMPslot48 = MCM.SMPONObjectFD48
		SMPslot50 = MCM.SMPONObjectFD50
		SMPslot51 = MCM.SMPONObjectFD51
		SMPslot60 = MCM.SMPONObjectFD60
	endIf
endfunction
