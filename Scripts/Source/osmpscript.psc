Scriptname OSmpScript extends Quest

; where female NPCs will be stored
actor[] SceneActors

; where female NPCs who already had SMP applied will be stored
actor[] SceneActorsHadSMP

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
	registerformodevent("ostim_end", "OstimEnd")

	PrintToConsole("Installed")
endevent


event OstimPreStart(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM, don't run this event
	if toggleDisableOSmp
		return
	endif

	PrintToConsole("Starting...")

	SceneActors = PapyrusUtil.ResizeActorArray(SceneActors, 0)
	SceneActorsHadSMP = PapyrusUtil.ResizeActorArray(SceneActorsHadSMP, 0)

	actor[] ActorsInScene = OThread.GetActors(0)

	actor currentActor

	int i = ActorsInScene.Length

	bool currentActorHadSMP

	while i
		i -= 1

		currentActor = ActorsInScene[i]

		if OStim.AppearsFemale(currentActor)
			SceneActors = PapyrusUtil.PushActor(SceneActors, currentActor)
			currentActorHadSMP = isActorSMP(currentActor)

			if currentActorHadSMP
				SceneActorsHadSMP = PapyrusUtil.PushActor(SceneActorsHadSMP, currentActor)
			else
				EquipSmpForActor(currentActor)
			endif
		endif
	endWhile

	PrintToConsole("Finished!")
endevent


event OstimEnd(string eventname, string strarg, float numarg, form sender)
	PrintToConsole("Checking if any actors need SMP cleaning...")

	int i = SceneActors.Length

	actor currentActor

	while i
		i -= 1

		currentActor = SceneActors[i]

		if isActorSMP(currentActor)
			RemoveSmpFromActor(currentActor, SceneActorsHadSMP.Find(currentActor) >= 0)
		endif
	endwhile

	SceneActors = PapyrusUtil.ResizeActorArray(SceneActors, 0)
	SceneActorsHadSMP = PapyrusUtil.ResizeActorArray(SceneActorsHadSMP, 0)
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
