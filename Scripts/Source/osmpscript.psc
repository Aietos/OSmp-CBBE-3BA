Scriptname OSmpScript extends Quest

actor partner
actor secondPartner

bool playerIsFemale = false
bool partnerIsFemale = false
bool secondPartnerIsFemale = false

bool undressAtAnimStart = true

bool partnerHadSMP = false
bool secondPartnerHadSMP = false

armor SMPslot48
armor SMPslot50
armor SMPslot51
armor SMPslot60



event oninit()
	ostim = OUtils.GetOStim()
	registerForModEvent("ostim_start", "OstimStart")
	registerformodevent("ostim_thirdactor_join", "OstimThirdJoin")
	registerformodevent("ostim_thirdactor_leave", "OstimThirdLeave")
	registerformodevent("ostim_end", "OstimEnd")
endevent


event OstimStart(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM, don't run this event
	if !ostim.isPlayerInvolved() || toggleDisableOSmp
		return
	endif

	OsexIntegrationMain.Console("OSmp: Starting...")

	actor dom = ostim.GetDomActor()
	actor sub = ostim.GetSubActor()
	secondPartner = ostim.GetThirdActor()

	if dom == PlayerRef
		partner = sub
	else
		partner = dom
	endif

	bool playerHadSMP = isPlayerSMP()
	playerIsFemale = ostim.isFemale(PlayerRef)

	partnerIsFemale = ostim.isFemale(partner)
	partnerHadSMP = isActorSMP(partner)

	if secondPartner != none
		secondPartnerIsFemale = ostim.isFemale(secondPartner)
		secondPartnerHadSMP = isActorSMP(secondPartner)
	endif

	OUndressScript oundress = ostim.GetUndressScript()
	undressAtAnimStart = ostim.AlwaysUndressAtAnimStart

	if (partnerIsFemale && !partnerHadSMP)
		EquipSmpForActor(partner)

		if undressAtAnimStart
			form[] partnerClothes = oundress.storeequipmentforms(partner, true)
			oundress.UnequipForms(partner, partnerClothes)
		endif
	endif

	if (secondPartner != none && secondPartnerIsFemale && !secondPartnerHadSMP)
		EquipSmpForActor(secondPartner)

		if undressAtAnimStart
			form[] secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif
	endif

	if (playerIsFemale && !playerHadSMP)
		OsexIntegrationMain.Console("OSmp: Applying SMP to player character ...")

		MCM.PlayerSMP()

		OsexIntegrationMain.Console("OSmp: SMP applied to player character")
	endif

	; we must toggle freecam off and on for SMP to properly apply to player character
	; only if user set the scene to start in freecam in OStim MCM
	; I have no idea why this is needed
	; in my tests, this was also needed outside of OStim scenes, SMP won't apply properly if you're in freecam
	; it is most likely a bug with 3BA/BHUNP SMP application, nothing I can do currently besides this freecam hack
	if playerIsFemale && !playerHadSMP && ostim.UseFreeCam && OSANative.IsFreeCam()
		ostim.ToggleFreeCam(false)
		ostim.ToggleFreeCam(true)
	endif

	OsexIntegrationMain.Console("OSmp: Finished!")
endevent


event OstimThirdJoin(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM or player is not in scene, don't run this event
	; OSmp won't run on NPC scenes
	if !ostim.isPlayerInvolved() || toggleDisableOSmp
		return
	endif

	secondPartner = ostim.GetThirdActor()
	secondPartnerIsFemale = ostim.isFemale(secondPartner)
	secondPartnerHadSMP = isActorSMP(secondPartner)

	OUndressScript oundress = ostim.GetUndressScript()

	if (secondPartnerIsFemale && !secondPartnerHadSMP)
		EquipSmpForActor(secondPartner)

		if undressAtAnimStart
			form[] secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif
	endif
endevent


event OstimThirdLeave(string eventname, string strarg, float numarg, form sender)
	if (secondPartnerIsFemale && (!toggleKeepNPCSMP || !secondPartnerHadSMP) && isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + partner.GetActorBase().GetName() + "...")
		MCM.RemoveSMP(secondPartner)
		OsexIntegrationMain.Console("OSmp: SMP cleaned from " + secondPartner.GetActorBase().GetName())
	endif
endevent


event OstimEnd(string eventname, string strarg, float numarg, form sender)
	; if numArg is not -1, it's a scene running on a subthread, and therefore an NPC scene
	if (numarg != -1)
		; a bug in OStim causes actors in main thread to redress if subthread scene ends
		; so undress them again
		OUndressScript oundress = ostim.GetUndressScript()
		if partner != none
			; wait for the redress to complete
			Utility.wait(2)
			; and then undress
			form[] partnerClothes = oundress.storeequipmentforms(partner, true)
			oundress.UnequipForms(partner, partnerClothes)
		endif
		if secondPartner != none
			form[] secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif
		return
	endif

	; however, there can be an NPC scene in main thread, so this check is also needed
	; if player is not in scene, skip, OSmp won't run on NPC scenes
	if !ostim.isPlayerInvolved()
		return
	endif

	OsexIntegrationMain.Console("OSmp: Checking if any actors need SMP cleaning...")

	if (playerIsFemale && !toggleKeepPlayerSMP && isPlayerSMP())
		OsexIntegrationMain.Console("OSmp: Removing SMP from player character...")
		MCM.RemoveSMP(PlayerRef)
		OsexIntegrationMain.Console("OSmp: SMP cleaned from player character")
	endif

	if (partnerIsFemale && (!toggleKeepNPCSMP || !partnerHadSMP) && isActorSMP(partner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + partner.GetActorBase().GetName() + "...")
		MCM.RemoveSMP(partner)
		OsexIntegrationMain.Console("OSmp: SMP cleaned from " + partner.GetActorBase().GetName())
	endif

	if (secondPartner != none && secondPartnerIsFemale && (!toggleKeepNPCSMP || !secondPartnerHadSMP) && isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + partner.GetActorBase().GetName() + "...")
		MCM.RemoveSMP(secondPartner)
		OsexIntegrationMain.Console("OSmp: SMP cleaned from " + secondPartner.GetActorBase().GetName())
	endif
endevent


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
		OsexIntegrationMain.Console("OSmp: " + partnerName + " is already in SMP mode")
	else
		OsexIntegrationMain.Console("OSmp: " + partnerName + " is in CBPC mode")
	endif

	return isSMP
endfunction


function EquipSmpForActor(Actor act)
	OsexIntegrationMain.Console("OSmp: Applying SMP to " + act.GetActorBase().GetName() + "...")

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
		act.AddItem(SMPslot48 as form, 1, true)
		act.EquipItem(SMPslot48 as form, true, true)
	elseIf MCM.SlotList[MCM.NPCsTIndex] == MCM.S50
		act.AddItem(SMPslot50 as form, 1, true)
		act.EquipItem(SMPslot50 as form, true, true)
	elseIf MCM.SlotList[MCM.NPCsTIndex] == MCM.S51
		act.AddItem(SMPslot51 as form, 1, true)
		act.EquipItem(SMPslot51 as form, true, true)
	elseIf MCM.SlotList[MCM.NPCsTIndex] == MCM.S60
		act.AddItem(SMPslot60 as form, 1, true)
		act.EquipItem(SMPslot60 as form, true, true)
	endIf

	OsexIntegrationMain.Console("OSmp: SMP applied to " + act.GetActorBase().GetName() + " with cup size " + cupSizeToUse)
endfunction


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


OsexIntegrationMain property ostim auto
actor property playerref auto
mus3baddonmcm property MCM auto
Mus3BPhysicsManager property PM auto
bool property toggleDisableOSmp = false auto
bool property toggleKeepPlayerSMP = true auto
bool property toggleKeepNPCSMP = true auto
bool property toggleAutomaticCup = true auto
float property aCupMaximumWeight = 25.0 auto
float property bCupMaximumWeight = 50.0 auto
float property cCupMaximumWeight = 75.0 auto
float property dCupMaximumWeight = 100.0 auto
