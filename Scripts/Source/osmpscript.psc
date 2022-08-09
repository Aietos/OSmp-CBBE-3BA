Scriptname OSmpScript extends Quest

form[] partnerClothes
form[] secondPartnerClothes

actor partner
actor secondPartner

bool playerIsFemale = false
bool partnerIsFemale = false
bool secondPartnerIsFemale = false

bool undressAtAnimStart = true

bool partnerHadSMP = false
bool secondPartnerHadSMP = false

event oninit()
	ostim = OUtils.GetOStim()
	registerformodevent("ostim_start", "OstimStart")
	registerformodevent("ostim_end", "OstimEnd")
	registerformodevent("ostim_thirdactor_join", "OstimThirdJoin")
	registerformodevent("ostim_thirdactor_leave", "OstimThirdLeave")
endevent

event OstimStart(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM, don't run this event
	if toggleDisableOSmp
		return
	endif

	Actor[] actors = ostim.GetActors()

	; if player is not in scene, skip, OSmp won't run on NPC scenes
	if actors[0] != PlayerRef && actors[1] != PlayerRef
		return
	endif

	undressAtAnimStart = ostim.AlwaysUndressAtAnimStart

	partner = ostim.GetSexPartner(PlayerRef)
	secondPartner = ostim.GetThirdActor()

	playerIsFemale = ostim.isFemale(PlayerRef)
	partnerIsFemale = ostim.isFemale(partner)

	partnerHadSMP = isActorSMP(partner)

	if secondPartner != none
		secondPartnerIsFemale = ostim.isFemale(secondPartner)
		secondPartnerHadSMP = isActorSMP(secondPartner)
	endif

	OUndressScript oundress = ostim.GetUndressScript()

	bool appliedSMPToPlayer = false

	OsexIntegrationMain.Console("OSmp: Starting...")

	if (playerIsFemale && !isPlayerSMP())
		OsexIntegrationMain.Console("OSmp: Applying SMP to player character ...")

		; if we don't wait, SMP may fail to be applied
		; no idea why...
		Utility.wait(2)
		MCM.PlayerSMP()

		; we must toggle free cam off and on for player character SMP to properly apply
		; only if user set the scene to start in free cam in OStim menu
		; I have no idea why this is needed either...
		if ostim.UseFreeCam
			ostim.ToggleFreeCam(false)
			ostim.ToggleFreeCam(true)
		endif

		appliedSMPToPlayer = true
	endif

	if (partnerIsFemale && !partnerHadSMP)
		OsexIntegrationMain.Console("OSmp: Applying SMP to " + partner.GetActorBase().GetName() + "...")

		if !appliedSMPToPlayer
			Utility.wait(2)
		endif

		MCM.NPCSMP(partner)

		if undressAtAnimStart
			partnerClothes = oundress.storeequipmentforms(partner, true)
			oundress.UnequipForms(partner, partnerClothes)
		endif
	endif

	if (secondPartner != none && secondPartnerIsFemale && !secondPartnerHadSMP)
		OsexIntegrationMain.Console("OSmp: Applying SMP to " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)

		if undressAtAnimStart
			secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif
	endif

	OsexIntegrationMain.Console("OSmp: Finished!")
endevent

event OstimThirdJoin(string eventname, string strarg, float numarg, form sender)
	; if OSmp is disabled in MCM, don't run this event
	if toggleDisableOSmp
		return
	endif

	Actor[] actors = ostim.GetActors()

	; if player is not in scene, skip, OSmp won't run on NPC scenes
	if actors[0] != PlayerRef && actors[1] != PlayerRef
		return
	endif

	secondPartner = actors[2]

	secondPartnerIsFemale = ostim.isFemale(secondPartner)
	secondPartnerHadSMP = isActorSMP(secondPartner)

	OUndressScript oundress = ostim.GetUndressScript()

	if (secondPartnerIsFemale && !secondPartnerHadSMP)
		OsexIntegrationMain.Console("OSmp: Applying SMP to " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)

		if undressAtAnimStart
			secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif

		OsexIntegrationMain.Console("OSmp: SMP applied to " + secondPartner.GetActorBase().GetName())
	endif
endevent

event OstimThirdLeave(string eventname, string strarg, float numarg, form sender)
	if (secondPartnerIsFemale && (!toggleKeepNPCSMP || !secondPartnerHadSMP) && isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)
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
			partnerClothes = oundress.storeequipmentforms(partner, true)
			oundress.UnequipForms(partner, partnerClothes)
		endif
		if secondPartner != none
			secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif
		return
	endif

	Actor[] actors = ostim.GetActors()

	; however, there can be an NPC scene in main thread, so this check is also needed
	; if player is not in scene, skip, OSmp won't run on NPC scenes
	if actors[0] != PlayerRef && actors[1] != PlayerRef
		return
	endif

	OsexIntegrationMain.Console("OSmp: Checking if any actors need SMP cleaning...")

	if (playerIsFemale && !toggleKeepPlayerSMP && isPlayerSMP())
		OsexIntegrationMain.Console("OSmp: Removing SMP from player character...")
		MCM.PlayerSMP()
	endif

	if (partnerIsFemale && (!toggleKeepNPCSMP || !partnerHadSMP) && isActorSMP(partner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + partner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(partner)
	endif

	if (secondPartner != none && secondPartnerIsFemale && (!toggleKeepNPCSMP || !secondPartnerHadSMP) && isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)
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
	armor NPCMain48
	armor NPCMain50
	armor NPCMain51
	armor NPCMain60

	bool isSMP = false

	String partnerName = partnerSMP.GetActorBase().GetName()

	if MCM.CupNum == 0
		NPCMain48 = MCM.SMPONObjectFA48
		NPCMain50 = MCM.SMPONObjectFA50
		NPCMain51 = MCM.SMPONObjectFA51
		NPCMain60 = MCM.SMPONObjectFA60
	elseIf MCM.CupNum == 1
		NPCMain48 = MCM.SMPONObjectFB48
		NPCMain50 = MCM.SMPONObjectFB50
		NPCMain51 = MCM.SMPONObjectFB51
		NPCMain60 = MCM.SMPONObjectFB60
	elseIf MCM.CupNum == 2
		NPCMain48 = MCM.SMPONObjectFC48
		NPCMain50 = MCM.SMPONObjectFC50
		NPCMain51 = MCM.SMPONObjectFC51
		NPCMain60 = MCM.SMPONObjectFC60
	elseIf MCM.CupNum == 3
		NPCMain48 = MCM.SMPONObjectFD48
		NPCMain50 = MCM.SMPONObjectFD50
		NPCMain51 = MCM.SMPONObjectFD51
		NPCMain60 = MCM.SMPONObjectFD60
	endIf

	if partnerSMP.GetItemCount(NPCMain48) != 0 && MCM.SlotList[MCM.NPCsTIndex] == MCM.S48
		isSMP = true
	elseIf partnerSMP.GetItemCount(NPCMain50) != 0 && MCM.SlotList[MCM.NPCsTIndex] == MCM.S50
		isSMP = true
	elseIf partnerSMP.GetItemCount(NPCMain51) != 0 && MCM.SlotList[MCM.NPCsTIndex] == MCM.S51
		isSMP = true
	elseIf partnerSMP.GetItemCount(NPCMain60) != 0 && MCM.SlotList[MCM.NPCsTIndex] == MCM.S60
		isSMP = true
	endif

	if isSMP
		OsexIntegrationMain.Console("OSmp: " + partnerName + " is already in SMP mode")
	else
		OsexIntegrationMain.Console("OSmp: " + partnerName + " is in CBPC mode")
	endif

	return isSMP
endfunction

OsexIntegrationMain property ostim auto
actor property playerref auto
mus3baddonmcm property MCM auto
bool property toggleDisableOSmp = false auto
bool property toggleKeepPlayerSMP = true auto
bool property toggleKeepNPCSMP = true auto
