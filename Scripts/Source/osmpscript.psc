Scriptname OSmpScript extends Quest

form[] partnerClothes
form[] secondPartnerClothes

actor partner
actor secondPartner

bool partnerIsFemale = false
bool secondPartnerIsFemale = false

bool undressAtAnimStart = true

event oninit()
	ostim = OUtils.GetOStim()
	registerformodevent("ostim_start", "OstimStart")
	registerformodevent("ostim_end", "OstimEnd")
	registerformodevent("ostim_thirdactor_join", "OstimThirdJoin")
	registerformodevent("ostim_thirdactor_leave", "OstimThirdLeave")
endevent

event OstimStart(string eventname, string strarg, float numarg, form sender)
	undressAtAnimStart = ostim.AlwaysUndressAtAnimStart

	partner = ostim.GetSexPartner(PlayerRef)
	secondPartner = ostim.GetThirdActor()

	partnerIsFemale = ostim.isFemale(partner)

	if secondPartner != none
		secondPartnerIsFemale = ostim.isFemale(secondPartner)
	endif

	OUndressScript oundress = ostim.GetUndressScript()

	OsexIntegrationMain.Console("OSmp: Starting...")

	if (partnerIsFemale && !isActorSMP(partner))
		OsexIntegrationMain.Console("OSmp: Applying SMP to " + partner.GetActorBase().GetName() + "...")
		Utility.wait(2)
		MCM.NPCSMP(partner)

		if undressAtAnimStart
			partnerClothes = oundress.storeequipmentforms(partner, true)
			oundress.UnequipForms(partner, partnerClothes)
		endif
	endif

	if (secondPartner != none && secondPartnerIsFemale && !isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Applying SMP to " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)

		if undressAtAnimStart
			secondPartnerClothes = oundress.storeequipmentforms(secondPartner, true)
			oundress.UnequipForms(secondPartner, secondPartnerClothes)
		endif
	endif

	OsexIntegrationMain.Console("OSmp: Finished applying SMP")
endevent

event OstimThirdJoin(string eventname, string strarg, float numarg, form sender)
	secondPartner = ostim.GetThirdActor()

	secondPartnerIsFemale = ostim.isFemale(secondPartner)

	OUndressScript oundress = ostim.GetUndressScript()

	if (secondPartnerIsFemale && !isActorSMP(secondPartner))
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
	if (secondPartnerIsFemale && isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)
		OsexIntegrationMain.Console("OSmp: SMP cleaned from " + secondPartner.GetActorBase().GetName())
	endif
endevent

event OstimEnd(string eventname, string strarg, float numarg, form sender)
	OsexIntegrationMain.Console("OSmp: Cleaning SMP...")

	if (partnerIsFemale && isActorSMP(partner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + partner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(partner)
	endif

	if (secondPartner != none && secondPartnerIsFemale && isActorSMP(secondPartner))
		OsexIntegrationMain.Console("OSmp: Removing SMP from " + secondPartner.GetActorBase().GetName() + "...")
		MCM.NPCSMP(secondPartner)
	endif

	OsexIntegrationMain.Console("OSmp: SMP cleaned!")
endevent

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
