scriptName Mus3BAddonMCM extends SKI_ConfigBase

Actor Property PlayerRef Auto

armor property SMPONObjectP48 auto
armor property SMPONObjectP50 auto
armor property SMPONObjectP51 auto
armor property SMPONObjectP60 auto

armor property SMPONObjectFA48 auto
armor property SMPONObjectFA50 auto
armor property SMPONObjectFA51 auto
armor property SMPONObjectFA60 auto

armor property SMPONObjectFB48 auto
armor property SMPONObjectFB50 auto
armor property SMPONObjectFB51 auto
armor property SMPONObjectFB60 auto

armor property SMPONObjectFC48 auto
armor property SMPONObjectFC50 auto
armor property SMPONObjectFC51 auto
armor property SMPONObjectFC60 auto

armor property SMPONObjectFD48 auto
armor property SMPONObjectFD50 auto
armor property SMPONObjectFD51 auto
armor property SMPONObjectFD60 auto

spell property Pspell auto
spell property FAspell auto
spell property FMultispell auto

Int Property PKEY_Default = 78 AutoReadOnly Hidden
Int property NPCKEY_Default = 73 AutoReadOnly hidden

Int property PKEY = 78 auto hidden ;numpad+
Int property NPCDKEY = 73 auto hidden ;numpad9

Int property CupNum = 3 Auto hidden

Int property FnumIndex = 0 auto hidden

Int property PsTIndex = 1 auto hidden
Int property NPCsTIndex = 1 auto hidden

Bool property PlayerGenderToggle = true auto hidden
Bool property NPCGenderToggle = true auto hidden
Bool property PlayerSpellToggle = false auto hidden
Bool property NPCSpellToggle = false auto hidden

Bool property PhysicsReset = true auto hidden

Bool property ClearToggle = false auto hidden

Bool property NPCMultiToggle = false auto hidden
Bool property NPCMultiAddToggle = true auto hidden

String[] property CupList auto hidden
String[] property SlotList auto hidden

String property S48 = "$SLOT48" AutoReadOnly hidden
String property S50 = "$SLOT50" AutoReadOnly hidden
String property S51 = "$SLOT51" AutoReadOnly hidden
String property S60 = "$SLOT60" AutoReadOnly hidden

String property Acup = "$ACup" AutoReadOnly hidden
String property Bcup = "$BCup" AutoReadOnly hidden
String property Ccup = "$CCup" AutoReadOnly hidden
String property Dcup = "$DCup" AutoReadOnly hidden

String Property SLOTINFO = "$SLOTINFO" AutoReadOnly hidden

Actor CrossHairRef

Mus3BPhysicsManager property PM auto

Int function GetVersion()
	return 13
endFunction

Event OnVersionUpdate(Int newVersion)
	OnConfigInit()
	if CurrentVersion == 2
		P_Toggle(false)
		NPC_Toggle(false)
	endIf
	If CurrentVersion < 9
		CupList = new String[4]
		CupList[0] = ACup
		CupList[1] = BCup
		CupList[2] = CCup
		CupList[3] = DCup
	endIf
	If CurrentVersion < 11
		PlayerRef = Game.GetPlayer()
	EndIf
endEvent

Event OnGameReload()
	parent.OnGameReload()
	RegisterForCrosshairRef()
	UpdateKeyRegistration()
	GoToState("")
EndEvent

Event OnInit()
	parent.OnInit()

	SlotList = new String[4]
	SlotList[0] = S48
	SlotList[1] = S50
	SlotList[2] = S51
	SlotList[3] = S60

	CupList = new String[4]
	CupList[0] = ACup
	CupList[1] = BCup
	CupList[2] = CCup
	CupList[3] = DCup

	RegisterForCrosshairRef()
	UpdateKeyRegistration()
endEvent

Event OnConfigInit()
	ModName = "$MODNAME"
	Pages = new String[2]
	Pages[0] = "$PageName_General"
	Pages[1] = "$PageName_ActorList"
endEvent

Event OnConfigOpen()
	ModName = "$MODNAME"
	Pages = new String[2]
	Pages[0] = "$PageName_General"
	Pages[1] = "$PageName_ActorList"
endEvent

Event OnConfigClose()
	if ClearToggle
		CLEAR_ActorList()
		ClearToggle = false
	endif
endEvent

Event OnPageReset(String pagename)
	if pagename == "" || pagename == "$PageName_General"
		Int iDisabledFlag = 0
		self.SetCursorFillMode(self.TOP_TO_BOTTOM)
		self.AddTextOption("$MODNAME", CurrentVersion)
		
		self.AddHeaderOption("$P_SETTINGS")
		self.AddToggleOptionST("OPTION_P_Gender_Toggle", "$PGENDERTOGGLE", PlayerGenderToggle, iDisabledFlag)
		self.AddMenuOptionST("OPTION_PlayerSlot", "$P_SLOT", SlotList[PsTIndex])
		self.AddToggleOptionST("OPTION_P_Spell_Toggle", "$P_SPELLTOGGLE", PlayerSpellToggle)
		self.AddKeyMapOptionST("OPTION_Keymap_P", "$P_KEYMAP", PKEY, OPTION_FLAG_WITH_UNMAP)
		self.AddToggleOptionST("OPTION_PhysicsReset_Toggle", "$PHYSICSRESETTOGGLE", PhysicsReset)
		self.AddToggleOptionST("OPTION_CheckLogging_Toggle", "$CHECKLOGGINGTOGGLE", PM.CheckLogging)
		self.AddToggleOptionST("OPTION_SwitchLogging_Toggle", "$SWITCHLOGGINGTOGGLE", PM.SwitchLogging)

		SetCursorPosition(1)
		AddEmptyOption()
		
		self.AddHeaderOption("$NPC_SETTINGS")
		self.AddToggleOptionST("OPTION_NPC_Gender_Toggle", "$NPCGENDERTOGGLE", NPCGenderToggle, iDisabledFlag)
		self.AddToggleOptionST("OPTION_NPC_Multiple_Toggle", "$NPCMULTIPLETOGGLE", NPCMultiToggle, iDisabledFlag)
		self.AddToggleOptionST("OPTION_NPC_MultipleAdd_Toggle", "$NPCMULTIPLEADDTOGGLE", NPCMultiAddToggle, iDisabledFlag)
		self.AddMenuOptionST("OPTION_FollowerSlot", "$NPC_SLOT", SlotList[NPCsTIndex])
		self.AddMenuOptionST("OPTION_NPC_CUP_KIND", "$NPC_CUPKIND", CupList[CupNum])
		self.AddToggleOptionST("OPTION_NPC_Spell_Toggle", "$NPC_SPELLTOGGLE", NPCSpellToggle)
		self.AddKeyMapOptionST("OPTION_Keymap_NPC", "$NPC_KEYMAP", NPCDKEY, OPTION_FLAG_WITH_UNMAP)
	elseif pagename == "$PageName_ActorList"	
		ActorListPage()
	endIf
	
endEvent

function ActorListPage()
	AddHeaderOption("$ActorListPageHeader")
	AddToggleOptionST("OPTION_CLEAR_LIST", "$ClearActorList", ClearToggle)

	int Size = PM.ActorPhysicsList.GetSize()
	int index = 0

	while index < 123 && index < Size
		actor thisActor = PM.ActorPhysicsList.GetAt(index) as actor
		AddTextOption(thisActor.GetActorBase().GetName() + " (" + thisActor.GetFormID() + ")", "")
		index += 1
	endwhile

	if Size > index
		AddTextOption("$NOTICE_Max_display", "")
	endIf
endFunction


state OPTION_PlayerSlot
	Event OnMenuOpenST()
		SetMenuDialogOptions(SlotList)
		SetMenuDialogStartIndex(PsTIndex)
		SetMenuDialogDefaultIndex(1)
	endEvent
	Event OnMenuAcceptST(Int index)
		PsTIndex = index
		SetMenuOptionValueST(SlotList[PsTIndex])
	endEvent
	Event OnHighlightST()
		SetInfoText(SLOTINFO)
	endEvent
endState

state OPTION_P_Gender_Toggle

	function OnSelectST()

		if PlayerGenderToggle == false
			PlayerGenderToggle = true
			self.SetToggleOptionValueST(true, false, "")
		else
			PlayerGenderToggle = false
			self.SetToggleOptionValueST(false, false, "")
		endIf
	endFunction

	function OnHighlightST()

		self.SetInfoText("$PGENDERTOGGLEINFO")
	endFunction
endState

state OPTION_P_Spell_Toggle
	Event OnSelectST()
		PlayerSpellToggle = !PlayerSpellToggle
		P_Toggle(PlayerSpellToggle)
		SetToggleOptionValueST(PlayerSpellToggle)
	endEvent
	Event OnHighlightST()
		SetInfoText("$P_SPELLTOGGLEINFO")
	endEvent
endState

state OPTION_PhysicsReset_Toggle
	Event OnSelectST()
		PhysicsReset = !PhysicsReset
		PM.ChangePhysicsResetState(PhysicsReset)
		SetToggleOptionValueST(PhysicsReset)
	endEvent
	Event OnHighlightST()
		SetInfoText("$PHYSICSRESETTOGGLEINFO")
	endEvent
endState

state OPTION_CheckLogging_Toggle
	Event OnSelectST()
		PM.CheckLogging = !PM.CheckLogging
		SetToggleOptionValueST(PM.CheckLogging)
	endEvent
	Event OnHighlightST()
		SetInfoText("$CHECKLOGGINGTOGGLEINFO")
	endEvent
endState

state OPTION_SwitchLogging_Toggle
	Event OnSelectST()
		PM.SwitchLogging = !PM.SwitchLogging
		SetToggleOptionValueST(PM.SwitchLogging)
	endEvent
	Event OnHighlightST()
		SetInfoText("$SWITCHLOGGINGTOGGLEINFO")
	endEvent
endState

state OPTION_Keymap_P
	Event OnKeyMapChangeST(Int keyCode, String conflictControl, String conflictName)
		SetKeyMapOptionValueST(keyCode)
		PKEY = keyCode
		UpdateKeyRegistration()
	endEvent
	Event OnHighlightST()
		SetInfoText("$P_HOTKEYINFO")
	endEvent
	Event OnDefaultST()
		PKEY = PKEY_Default
		SetKeyMapOptionValueST(PKEY_Default)
	endEvent
endState

state OPTION_FollowerSlot
	Event OnMenuOpenST()
		SetMenuDialogOptions(SlotList)
		SetMenuDialogStartIndex(NPCsTIndex)
		SetMenuDialogDefaultIndex(1)
	endEvent
	Event OnMenuAcceptST(Int index)
		NPCsTIndex = index
		SetMenuOptionValueST(SlotList[NPCsTIndex])
	endEvent
	Event OnHighlightST()
		SetInfoText(SLOTINFO)
	endEvent
endState

state OPTION_NPC_CUP_KIND
	Event OnMenuOpenST()
		SetMenuDialogOptions(CupList)
		SetMenuDialogStartIndex(CupNum)
		SetMenuDialogDefaultIndex(3)
	endEvent
	Event OnMenuAcceptST(Int index)
		CupNum = index
		SetMenuOptionValueST(CupList[CupNum])
	endEvent
	Event OnHighlightST()
		SetInfoText("$NPC_CUPKINDINFO")
	endEvent
endState

state OPTION_NPC_Gender_Toggle

	function OnSelectST()

		if NPCGenderToggle == false
			NPCGenderToggle = true
			self.SetToggleOptionValueST(true, false, "")
		else
			NPCGenderToggle = false
			self.SetToggleOptionValueST(false, false, "")
		endIf
	endFunction

	function OnHighlightST()

		self.SetInfoText("$NPCGENDERTOGGLEINFO")
	endFunction
endState

state OPTION_NPC_Multiple_Toggle

	function OnSelectST()

		if NPCMultiToggle == false
			NPCMultiToggle = true
			self.SetToggleOptionValueST(true, false, "")
		else
			NPCMultiToggle = false
			self.SetToggleOptionValueST(false, false, "")
		endIf
	endFunction

	function OnHighlightST()

		self.SetInfoText("$NPCMULTIPLETOGGLEINFO")
	endFunction
endState

state OPTION_NPC_MultipleAdd_Toggle

	function OnSelectST()

		if NPCMultiAddToggle == false
			NPCMultiAddToggle = true
			self.SetToggleOptionValueST(true, false, "")
		else
			NPCMultiAddToggle = false
			self.SetToggleOptionValueST(false, false, "")
		endIf
	endFunction

	function OnHighlightST()

		self.SetInfoText("$NPCMULTIPLEADDTOGGLEINFO")
	endFunction
endState

state OPTION_NPC_Spell_Toggle
	Event OnSelectST()
		NPCSpellToggle = !NPCSpellToggle
		NPC_Toggle(NPCSpellToggle)
		SetToggleOptionValueST(NPCSpellToggle)
	endEvent
	Event OnHighlightST()
		SetInfoText("$NPC_SPELLTOGGLEINFO")
	endEvent
endState

state OPTION_Keymap_NPC
	Event OnKeyMapChangeST(Int keyCode, String conflictControl, String conflictName)
		SetKeyMapOptionValueST(keyCode)
		NPCDKEY = keyCode
		UpdateKeyRegistration()
	endEvent
	Event OnHighlightST()
		SetInfoText("$NPC_HOTKEYINFO")
	endEvent
	Event OnDefaultST()
		NPCDKEY = NPCKEY_Default
		SetKeyMapOptionValueST(NPCKEY_Default)
	endEvent
endState

state OPTION_CLEAR_LIST

	function OnSelectST()

		if ClearToggle == false
			ClearToggle = true
			self.SetToggleOptionValueST(true, false, "")
		else
			ClearToggle = false
			self.SetToggleOptionValueST(false, false, "")
		endIf
	endFunction

	function OnHighlightST()
		self.SetInfoText("$ACTORLIST_CLEAR_INFO")
	endFunction
endState

function CLEAR_ActorList()
	Debug.Notification("Cleaning SMP Actor List...")
	PM.CancleActorList()
	
	int Size = PM.ActorPhysicsList.GetSize()
	int index = 0
	
	while index < Size
		actor thisActor = PM.ActorPhysicsList.GetAt(index) as actor
		RemoveSMP(thisActor)
		index += 1
	endwhile
	
	PM.CleanActorList()
	Debug.Notification("Cleaning SMP Actor List done")
endFunction

Event OnCrosshairRefChange(ObjectReference ref)
	CrossHairRef = ref as Actor
endEvent

Event OnKeyDown(Int keyCode)
	If keyCode == PKEY && !Utility.IsInMenuMode()
		PlayerSMP()
	ElseIf keyCode == NPCDKEY && !Utility.IsInMenuMode()
		if NPCMultiToggle
			FMultispell.Cast(PlayerRef)
		else
			If CrossHairRef != None
				NPCSMP(CrossHairRef)
			EndIf
		endif
	EndIf
endEvent

function UpdateKeyRegistration()
	UnregisterForAllKeys()
	If PKEY != -1
		RegisterForKey(PKEY)
	EndIf
	If NPCDKEY != -1
		RegisterForKey(NPCDKEY)
	EndIf
endFunction

function P_Toggle(Bool toggle)
	If toggle
		PlayerRef.AddSpell(Pspell, true)
	Else
		PlayerRef.RemoveSpell(Pspell)
	EndIf
endFunction

function NPC_Toggle(bool toggle)
	If toggle
		PlayerRef.AddSpell(FAspell, true)
		PlayerRef.AddSpell(FMultispell, true)
	Else
		PlayerRef.RemoveSpell(FAspell)
		PlayerRef.RemoveSpell(FMultispell)
	EndIf
endFunction

State BlockedEvents
	function PlayerSMP()
	endFunction
	function NPCSMP(actor akTarget)
	endFunction
EndState

function PlayerSMP()
	GoToState("BlockedEvents")
	if PlayerGenderToggle == true
		if PlayerRef.GetActorBase().GetSex() != 1
			if PM.SwitchLogging == true
				debug.Notification("Cannot use unless the Player's female")
			endif
			GoToState("")
			return
		endif
	endif	
		
	if PlayerRef.GetItemCount(SMPONObjectP48) != 0 && SlotList[PsTIndex] == S48
		PlayerRef.UnequipItem(SMPONObjectP48, false, true)
		PlayerRef.RemoveItem(SMPONObjectP48, 99, true, none)
		PM.CBPCPhysicsAccess(PlayerRef)
		if PM.SwitchLogging == true
		debug.Notification("Player 3BA CBPC Mode")
		endif
	elseIf PlayerRef.GetItemCount(SMPONObjectP50) != 0 && SlotList[PsTIndex] == S50
		PlayerRef.UnequipItem(SMPONObjectP50, false, true)
		PlayerRef.RemoveItem(SMPONObjectP50, 99, true, none)
		PM.CBPCPhysicsAccess(PlayerRef)
		if PM.SwitchLogging == true
		debug.Notification("Player 3BA CBPC Mode")
		endif
	elseIf PlayerRef.GetItemCount(SMPONObjectP51) != 0 && SlotList[PsTIndex] == S51
		PlayerRef.UnequipItem(SMPONObjectP51, false, true)
		PlayerRef.RemoveItem(SMPONObjectP51, 99, true, none)
		PM.CBPCPhysicsAccess(PlayerRef)
		if PM.SwitchLogging == true
		debug.Notification("Player 3BA CBPC Mode")
		endif
	elseIf PlayerRef.GetItemCount(SMPONObjectP60) != 0 && SlotList[PsTIndex] == S60
		PlayerRef.UnequipItem(SMPONObjectP60, false, true)
		PlayerRef.RemoveItem(SMPONObjectP60, 99, true, none)
		PM.CBPCPhysicsAccess(PlayerRef)
		if PM.SwitchLogging == true
		debug.Notification("Player 3BA CBPC Mode")
		endif
	else
		PlayerRef.UnequipItem(SMPONObjectP48, false, true)
		PlayerRef.RemoveItem(SMPONObjectP48, 99, true, none)
		PlayerRef.UnequipItem(SMPONObjectP50, false, true)
		PlayerRef.RemoveItem(SMPONObjectP50, 99, true, none)
		PlayerRef.UnequipItem(SMPONObjectP51, false, true)
		PlayerRef.RemoveItem(SMPONObjectP51, 99, true, none)
		PlayerRef.UnequipItem(SMPONObjectP60, false, true)
		PlayerRef.RemoveItem(SMPONObjectP60, 99, true, none)
		if SlotList[PsTIndex] == S48
			PM.CBPCPhysicsAccess(PlayerRef, true)
			PlayerRef.AddItem(SMPONObjectP48, 1, true)
			PlayerRef.EquipItem(SMPONObjectP48, true, true)
			if PM.SwitchLogging == true
			debug.Notification("Player 3BA SMP Mode")
			endif
		elseIf SlotList[PsTIndex] == S50
			PM.CBPCPhysicsAccess(PlayerRef, true)
			PlayerRef.AddItem(SMPONObjectP50, 1, true)
			PlayerRef.EquipItem(SMPONObjectP50, true, true)
			if PM.SwitchLogging == true
			debug.Notification("Player 3BA SMP Mode")
			endif
		elseIf SlotList[PsTIndex] == S51
			PM.CBPCPhysicsAccess(PlayerRef, true)
			PlayerRef.AddItem(SMPONObjectP51, 1, true)
			PlayerRef.EquipItem(SMPONObjectP51, true, true)
			if PM.SwitchLogging == true
			debug.Notification("Player 3BA SMP Mode")
			endif
		elseIf SlotList[PsTIndex] == S60
			PM.CBPCPhysicsAccess(PlayerRef, true)
			PlayerRef.AddItem(SMPONObjectP60, 1, true)
			PlayerRef.EquipItem(SMPONObjectP60, true, true)
			if PM.SwitchLogging == true
			debug.Notification("Player 3BA SMP Mode")
			endif
		endIf
	endIf
	GoToState("")
endFunction

function NPCSMP(actor akTarget)
	GoToState("BlockedEvents")
	armor NPCMain48
	armor NPCMain50
	armor NPCMain51
	armor NPCMain60
	String ActorName = akTarget.GetActorBase().GetName()
	
	if NPCGenderToggle == True
		if akTarget.GetActorBase().GetSex() != 1 && akTarget.GetLeveledActorBase().GetSex() != 1
			if PM.SwitchLogging == true
			debug.Notification("Cannot use unless " + ActorName + " is female")
			endif
			GoToState("")
			return
		endif
	endif

	if CupNum == 0
		NPCMain48 = SMPONObjectFA48
		NPCMain50 = SMPONObjectFA50
		NPCMain51 = SMPONObjectFA51
		NPCMain60 = SMPONObjectFA60
	elseIf CupNum == 1
		NPCMain48 = SMPONObjectFB48
		NPCMain50 = SMPONObjectFB50
		NPCMain51 = SMPONObjectFB51
		NPCMain60 = SMPONObjectFB60
	elseIf CupNum == 2
		NPCMain48 = SMPONObjectFC48
		NPCMain50 = SMPONObjectFC50
		NPCMain51 = SMPONObjectFC51
		NPCMain60 = SMPONObjectFC60
	elseIf CupNum == 3
		NPCMain48 = SMPONObjectFD48
		NPCMain50 = SMPONObjectFD50
		NPCMain51 = SMPONObjectFD51
		NPCMain60 = SMPONObjectFD60
	endIf

	if akTarget.GetItemCount(NPCMain48) != 0 && SlotList[NPCsTIndex] == S48
		akTarget.UnequipItem(NPCMain48, false, true)
		akTarget.RemoveItem(NPCMain48, 99, true, none)
		PM.CBPCPhysicsAccess(akTarget)
		if PM.SwitchLogging == true
		debug.Notification(ActorName + " 3BA CBPC Mode")
		endif
	elseIf akTarget.GetItemCount(NPCMain50) != 0 && SlotList[NPCsTIndex] == S50
		akTarget.UnequipItem(NPCMain50, false, true)
		akTarget.RemoveItem(NPCMain50, 99, true, none)
		PM.CBPCPhysicsAccess(akTarget)
		if PM.SwitchLogging == true
		debug.Notification(ActorName + " 3BA CBPC Mode")
		endif
	elseIf akTarget.GetItemCount(NPCMain51) != 0 && SlotList[NPCsTIndex] == S51
		akTarget.UnequipItem(NPCMain51, false, true)
		akTarget.RemoveItem(NPCMain51, 99, true, none)
		PM.CBPCPhysicsAccess(akTarget)
		if PM.SwitchLogging == true
		debug.Notification(ActorName + " 3BA CBPC Mode")
		endif
	elseIf akTarget.GetItemCount(NPCMain60) != 0 && SlotList[NPCsTIndex] == S60
		akTarget.UnequipItem(NPCMain60, false, true)
		akTarget.RemoveItem(NPCMain60, 99, true, none)
		PM.CBPCPhysicsAccess(akTarget)
		if PM.SwitchLogging == true
		debug.Notification(ActorName + " 3BA CBPC Mode")
		endif
	else
		akTarget.UnequipItem(SMPONObjectFA48, false, true)
		akTarget.RemoveItem(SMPONObjectFA48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA50, false, true)
		akTarget.RemoveItem(SMPONObjectFA50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA51, false, true)
		akTarget.RemoveItem(SMPONObjectFA51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA60, false, true)
		akTarget.RemoveItem(SMPONObjectFA60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB48, false, true)
		akTarget.RemoveItem(SMPONObjectFB48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB50, false, true)
		akTarget.RemoveItem(SMPONObjectFB50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB51, false, true)
		akTarget.RemoveItem(SMPONObjectFB51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB60, false, true)
		akTarget.RemoveItem(SMPONObjectFB60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC48, false, true)
		akTarget.RemoveItem(SMPONObjectFC48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC50, false, true)
		akTarget.RemoveItem(SMPONObjectFC50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC51, false, true)
		akTarget.RemoveItem(SMPONObjectFC51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC60, false, true)
		akTarget.RemoveItem(SMPONObjectFC60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD48, false, true)
		akTarget.RemoveItem(SMPONObjectFD48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD50, false, true)
		akTarget.RemoveItem(SMPONObjectFD50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD51, false, true)
		akTarget.RemoveItem(SMPONObjectFD51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD60, false, true)
		akTarget.RemoveItem(SMPONObjectFD60, 99, true, none)
		if CupNum == 0
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		elseIf CupNum == 1
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		elseIf CupNum == 2
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		elseIf CupNum == 3
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		endIf
	endIf
	GoToState("")
endFunction

function MultilpleSMP(actor akTarget)
	if NPCMultiAddToggle
		AddNPCSMP(akTarget)
	else
		RemoveSMP(akTarget, true)
	endif
endFunction


function AddNPCSMP(actor akTarget)
	if akTarget == PlayerRef
		return
	endif
	
	armor NPCMain48
	armor NPCMain50
	armor NPCMain51
	armor NPCMain60
	String ActorName = akTarget.GetActorBase().GetName()
	
	if NPCGenderToggle == True
		if akTarget.GetActorBase().GetSex() != 1 && akTarget.GetLeveledActorBase().GetSex() != 1
			if PM.SwitchLogging == true
			debug.Notification("Cannot use unless " + ActorName + " is female")
			endif
			return
		endif
	endif

	if CupNum == 0
		NPCMain48 = SMPONObjectFA48
		NPCMain50 = SMPONObjectFA50
		NPCMain51 = SMPONObjectFA51
		NPCMain60 = SMPONObjectFA60
	elseIf CupNum == 1
		NPCMain48 = SMPONObjectFB48
		NPCMain50 = SMPONObjectFB50
		NPCMain51 = SMPONObjectFB51
		NPCMain60 = SMPONObjectFB60
	elseIf CupNum == 2
		NPCMain48 = SMPONObjectFC48
		NPCMain50 = SMPONObjectFC50
		NPCMain51 = SMPONObjectFC51
		NPCMain60 = SMPONObjectFC60
	elseIf CupNum == 3
		NPCMain48 = SMPONObjectFD48
		NPCMain50 = SMPONObjectFD50
		NPCMain51 = SMPONObjectFD51
		NPCMain60 = SMPONObjectFD60
	endIf

	if akTarget.GetItemCount(NPCMain48) != 0 && SlotList[NPCsTIndex] == S48
		return
	elseIf akTarget.GetItemCount(NPCMain50) != 0 && SlotList[NPCsTIndex] == S50
		return
	elseIf akTarget.GetItemCount(NPCMain51) != 0 && SlotList[NPCsTIndex] == S51
		return
	elseIf akTarget.GetItemCount(NPCMain60) != 0 && SlotList[NPCsTIndex] == S60
		return
	else
		akTarget.UnequipItem(SMPONObjectFA48, false, true)
		akTarget.RemoveItem(SMPONObjectFA48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA50, false, true)
		akTarget.RemoveItem(SMPONObjectFA50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA51, false, true)
		akTarget.RemoveItem(SMPONObjectFA51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA60, false, true)
		akTarget.RemoveItem(SMPONObjectFA60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB48, false, true)
		akTarget.RemoveItem(SMPONObjectFB48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB50, false, true)
		akTarget.RemoveItem(SMPONObjectFB50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB51, false, true)
		akTarget.RemoveItem(SMPONObjectFB51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB60, false, true)
		akTarget.RemoveItem(SMPONObjectFB60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC48, false, true)
		akTarget.RemoveItem(SMPONObjectFC48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC50, false, true)
		akTarget.RemoveItem(SMPONObjectFC50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC51, false, true)
		akTarget.RemoveItem(SMPONObjectFC51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC60, false, true)
		akTarget.RemoveItem(SMPONObjectFC60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD48, false, true)
		akTarget.RemoveItem(SMPONObjectFD48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD50, false, true)
		akTarget.RemoveItem(SMPONObjectFD50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD51, false, true)
		akTarget.RemoveItem(SMPONObjectFD51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD60, false, true)
		akTarget.RemoveItem(SMPONObjectFD60, 99, true, none)
		if CupNum == 0
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		elseIf CupNum == 1
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		elseIf CupNum == 2
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		elseIf CupNum == 3
			if SlotList[NPCsTIndex] == S48
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain48, 1, true)
				akTarget.EquipItem(NPCMain48, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S50
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain50, 1, true)
				akTarget.EquipItem(NPCMain50, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S51
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain51, 1, true)
				akTarget.EquipItem(NPCMain51, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			elseIf SlotList[NPCsTIndex] == S60
				PM.CBPCPhysicsAccess(akTarget, true)
				akTarget.AddItem(NPCMain60, 1, true)
				akTarget.EquipItem(NPCMain60, true, true)
				if PM.SwitchLogging == true
				debug.Notification(ActorName + " 3BA SMP Mode")
				endif
			endIf
		endIf
	endIf
endFunction

function RemoveSMP(actor akTarget, bool isSpell = false)
	if isSpell == true
		if akTarget == PlayerRef
			return
		endif
	endif

	if akTarget == PlayerRef
		if PlayerGenderToggle == true
			if PlayerRef.GetActorBase().GetSex() != 1
				return
			endif
		endif	
		
		PlayerRef.UnequipItem(SMPONObjectP48, false, true)
		PlayerRef.RemoveItem(SMPONObjectP48, 99, true, none)
		PlayerRef.UnequipItem(SMPONObjectP50, false, true)
		PlayerRef.RemoveItem(SMPONObjectP50, 99, true, none)
		PlayerRef.UnequipItem(SMPONObjectP51, false, true)
		PlayerRef.RemoveItem(SMPONObjectP51, 99, true, none)
		PlayerRef.UnequipItem(SMPONObjectP60, false, true)
		PlayerRef.RemoveItem(SMPONObjectP60, 99, true, none)
		
		PM.CBPCPhysicsAccess(PlayerRef)
		if PM.SwitchLogging == true
		debug.Notification("Player 3BA CBPC Mode")
		endif
	else
		String ActorName = akTarget.GetActorBase().GetName()
		
		if NPCGenderToggle == True
			if akTarget.GetActorBase().GetSex() != 1 && akTarget.GetLeveledActorBase().GetSex() != 1
				return
			endif
		endif

		akTarget.UnequipItem(SMPONObjectFA48, false, true)
		akTarget.RemoveItem(SMPONObjectFA48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA50, false, true)
		akTarget.RemoveItem(SMPONObjectFA50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA51, false, true)
		akTarget.RemoveItem(SMPONObjectFA51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFA60, false, true)
		akTarget.RemoveItem(SMPONObjectFA60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB48, false, true)
		akTarget.RemoveItem(SMPONObjectFB48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB50, false, true)
		akTarget.RemoveItem(SMPONObjectFB50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB51, false, true)
		akTarget.RemoveItem(SMPONObjectFB51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFB60, false, true)
		akTarget.RemoveItem(SMPONObjectFB60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC48, false, true)
		akTarget.RemoveItem(SMPONObjectFC48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC50, false, true)
		akTarget.RemoveItem(SMPONObjectFC50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC51, false, true)
		akTarget.RemoveItem(SMPONObjectFC51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFC60, false, true)
		akTarget.RemoveItem(SMPONObjectFC60, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD48, false, true)
		akTarget.RemoveItem(SMPONObjectFD48, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD50, false, true)
		akTarget.RemoveItem(SMPONObjectFD50, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD51, false, true)
		akTarget.RemoveItem(SMPONObjectFD51, 99, true, none)
		akTarget.UnequipItem(SMPONObjectFD60, false, true)
		akTarget.RemoveItem(SMPONObjectFD60, 99, true, none)
		
		PM.CBPCPhysicsAccess(akTarget)
		if PM.SwitchLogging == true
		debug.Notification(ActorName + " 3BA CBPC Mode")
		endif
	endif
endFunction

