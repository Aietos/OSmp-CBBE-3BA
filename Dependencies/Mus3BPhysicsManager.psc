Scriptname Mus3BPhysicsManager extends Quest  

import NetImmerse

Formlist Property ActorPhysicsList auto

Bool Property PhysicsResetOn = true auto hidden

string Property LPreBreast01Name = "L PreBreast01" autoReadOnly
string Property LPreBreast02Name = "L PreBreast02" autoReadOnly
string Property LPreBreast03Name = "L PreBreast03" autoReadOnly
string Property RPreBreast01Name = "R PreBreast01" autoReadOnly
string Property RPreBreast02Name = "R PreBreast02" autoReadOnly
string Property RPreBreast03Name = "R PreBreast03" autoReadOnly

string Property LBreast01Name = "L Breast01" autoReadOnly
string Property LBreast02Name = "L Breast02" autoReadOnly
string Property LBreast03Name = "L Breast03" autoReadOnly
string Property RBreast01Name = "R Breast01" autoReadOnly
string Property RBreast02Name = "R Breast02" autoReadOnly
string Property RBreast03Name = "R Breast03" autoReadOnly

string Property ButtLName = "NPC L Butt" autoReadOnly
string Property ButtRName = "NPC R Butt" autoReadOnly

string Property LFrontThighName = "NPC L FrontThigh" autoReadOnly
string Property RFrontThighName = "NPC R FrontThigh" autoReadOnly
string Property LRearThighName = "NPC L RearThigh" autoReadOnly
string Property RRearThighName = "NPC R RearThigh" autoReadOnly
string Property LRearCalfName = "NPC L RearCalf [LrClf]" autoReadOnly
string Property RRearCalfName = "NPC R RearCalf [RrClf]" autoReadOnly

string Property LPussy2Name = "NPC L Pussy02" autoReadOnly
string Property LPussy1Name = "NPC L Pussy01" autoReadOnly
string Property RPussy2Name = "NPC R Pussy02" autoReadOnly
string Property RPussy1Name = "NPC R Pussy01" autoReadOnly

string Property PelvisName = "NPC Pelvis [Pelv]" autoReadOnly

string Property VaginaB1Name = "VaginaB1" autoReadOnly
string Property Clitoral1Name = "Clitoral1" autoReadOnly

string Property NPCBellyName = "NPC Belly" autoReadOnly
string Property HDTBellyName = "HDT Belly" autoReadOnly

float[] EmptyPoint
float[] LBreast01Pos
float[] LBreast02Pos
float[] LBreast03Pos
float[] RBreast01Pos
float[] RBreast02Pos
float[] RBreast03Pos
float[] FrontThighPos
float[] RearThighPos
float[] RearCalfPos
float[] LPussy1Pos
float[] RPussy1Pos
float[] LPussy2Pos
float[] RPussy2Pos
float[] ClitoralPos
float[] VaginaBPos
float[] NPCBellyPos

int Property Version = 0 auto hidden

Bool Property CheckLogging = true auto hidden
Bool Property SwitchLogging = true auto hidden

Event OnInit()
	Version = 4
	DataManager(1)
	InitialArrays()
	InitialPos()
EndEvent

function InitialArrays()
	EmptyPoint		= new Float[3]
	LBreast01Pos	= new Float[3]
	LBreast02Pos	= new Float[3]
	LBreast03Pos	= new Float[3]
	RBreast01Pos	= new Float[3]
	RBreast02Pos	= new Float[3]
	RBreast03Pos	= new Float[3]
	FrontThighPos	= new Float[3]
	RearThighPos	= new Float[3]
	RearCalfPos		= new Float[3]
	LPussy1Pos		= new Float[3]
	RPussy1Pos		= new Float[3]
	LPussy2Pos		= new Float[3]
	RPussy2Pos		= new Float[3]
	ClitoralPos		= new Float[3]
	VaginaBPos		= new Float[3]
	NPCBellyPos		= new Float[3]
endFunction

function InitialPos()
	EmptyPoint[0] = 0.0
	EmptyPoint[1] = 0.0
	EmptyPoint[2] = 0.0
	
	LBreast01Pos[0] = -1.120057
	LBreast01Pos[1] = 3.090759
	LBreast01Pos[2] = -0.538383
	
	LBreast02Pos[0] = -1.330020
	LBreast02Pos[1] = 3.670190
	LBreast02Pos[2] = -0.524490
	
	LBreast03Pos[0] = -1.314233
	LBreast03Pos[1] = 3.626562
	LBreast03Pos[2] = 0.583305
	
	RBreast01Pos[0] = 1.120055
	RBreast01Pos[1] = 3.090774
	RBreast01Pos[2] = -0.538383
	
	RBreast02Pos[0] = 1.330017
	RBreast02Pos[1] = 3.670176
	RBreast02Pos[2] = -0.524536
	
	RBreast03Pos[0] = 1.314238
	RBreast03Pos[1] = 3.626567
	RBreast03Pos[2] = 0.583328
	
	FrontThighPos[0] = 0.0
	FrontThighPos[1] = 3.438000
	FrontThighPos[2] = 0.0

	RearThighPos[0] = 0.0
	RearThighPos[1] = -2.309000
	RearThighPos[2] = 0.0

	RearCalfPos[0] = 0.0
	RearCalfPos[1] = -2.832000
	RearCalfPos[2] = 0.0
	
	LPussy1Pos[0] = -2.000000
	LPussy1Pos[1] = 0.0
	LPussy1Pos[2] = -1.000008
	
	RPussy1Pos[0] = 2.000000
	RPussy1Pos[1] = 0.0
	RPussy1Pos[2] = -1.000008
	
	LPussy2Pos[0] = -1.0
	LPussy2Pos[1] = -0.000001
	LPussy2Pos[2] = -3.0
	
	RPussy2Pos[0] = 1.0
	RPussy2Pos[1] = -0.000001
	RPussy2Pos[2] = -3.0
	
	ClitoralPos[0] = 0.000582
	ClitoralPos[1] = -1.390759
	ClitoralPos[2] = -2.095268
	
	VaginaBPos[0] = 0.000735
	VaginaBPos[1] = -2.475235
	VaginaBPos[2] = -1.987076
	
	NPCBellyPos[0] = 0.0
	NPCBellyPos[1] = 7.0
	NPCBellyPos[2] = 0.0
endFunction

function ActorListAccess (actor target, bool IsRemovethis = false)
	if IsRemovethis
		MiscUtil.PrintConsole("Added " + target.GetActorBase().GetName() + " in ActorSMPPhysicsList")
		ActorPhysicsList.AddForm(target)
	else
		MiscUtil.PrintConsole("Removed " + target.GetActorBase().GetName() + " in ActorSMPPhysicsList")
		ActorPhysicsList.RemoveAddedForm(target)
	endif
endFunction


function ApplyActorList()
	int index = 0
	int ValidCount = ActorPhysicsList.GetSize()
	
	while index < ValidCount
		actor target = ActorPhysicsList.GetAt(index) as actor
		MiscUtil.PrintConsole("Switch Physics CBPC to SMP : " + target.GetActorBase().GetName() + "(" + target.GetFormID() + ")")
		CBPCPhysicsAccess(target, true, true)
		index += 1
	endWhile
	
	if CheckLogging == true
	Debug.Notification("Apply Actor SMP Physics List done")
	endif
endFunction

function CancleActorList()
	int index = 0
	int ValidCount = ActorPhysicsList.GetSize()
	
	while index < ValidCount
		actor target = ActorPhysicsList.GetAt(index) as actor
		MiscUtil.PrintConsole("Switch Physics SMP to CBPC : " + target.GetActorBase().GetName() + "(" + target.GetFormID() + ")")
		CBPCPhysicsAccess(target, false, true)
		index += 1
	endWhile
endFunction

function CleanActorList()
	ActorPhysicsList.Revert()
endFunction

function CBPCPhysicsAccess(actor target, bool Pstop = false, bool initial = false)
	if !initial
		ActorListAccess(target, Pstop)
	endif
	CBPCBreasts(target, Pstop)
	CBPCButts(target, Pstop)
	CBPCBelly(target, Pstop)
	CBPCVaginaCollision(target, Pstop)
	CBPCVagina(target, Pstop)
	CBPCThigh(target, Pstop)
endFunction

function CBPCBreasts(actor target, bool Pstop = false)
	if !BreastSMP
		return
	endif
	
	if !Pstop
		CBPCPluginScript.StartPhysics(target, LBreast01Name)
		CBPCPluginScript.StartPhysics(target, LBreast02Name)
		CBPCPluginScript.StartPhysics(target, LBreast03Name)
		CBPCPluginScript.StartPhysics(target, RBreast01Name)
		CBPCPluginScript.StartPhysics(target, RBreast02Name)
		CBPCPluginScript.StartPhysics(target, RBreast03Name)
	else
		CBPCPluginScript.StopPhysics(target, LBreast01Name)
		CBPCPluginScript.StopPhysics(target, LBreast02Name)
		CBPCPluginScript.StopPhysics(target, LBreast03Name)
		CBPCPluginScript.StopPhysics(target, RBreast01Name)
		CBPCPluginScript.StopPhysics(target, RBreast02Name)
		CBPCPluginScript.StopPhysics(target, RBreast03Name)

		CBPCBreastsReset(target)
	endif
endFunction

function CBPCBreastsReset(actor target)
	if !PhysicsResetOn
		return
	endif
	
	if HasNode(target as ObjectReference, LPreBreast01Name, false)
		SetNodeLocalPosition(target as ObjectReference, LBreast01Name, EmptyPoint, false)
	else
		SetNodeLocalPosition(target as ObjectReference, LBreast01Name, LBreast01Pos, false)
	endif
	SetNodeLocalRotationEuler(target as ObjectReference, LBreast01Name, EmptyPoint, false)

	if HasNode(target as ObjectReference, RPreBreast01Name, false)
		SetNodeLocalPosition(target as ObjectReference, RBreast01Name, EmptyPoint, false)
	else
		SetNodeLocalPosition(target as ObjectReference, RBreast01Name, RBreast01Pos, false)
	endif
	SetNodeLocalRotationEuler(target as ObjectReference, RBreast01Name, EmptyPoint, false)
	
	if HasNode(target as ObjectReference, LPreBreast02Name, false)
		SetNodeLocalPosition(target as ObjectReference, LBreast02Name, EmptyPoint, false)
	else
		SetNodeLocalPosition(target as ObjectReference, LBreast02Name, LBreast02Pos, false)
	endif
	SetNodeLocalRotationEuler(target as ObjectReference, LBreast02Name, EmptyPoint, false)
	
	
	if HasNode(target as ObjectReference, RPreBreast02Name, false)
		SetNodeLocalPosition(target as ObjectReference, RBreast02Name, EmptyPoint, false)
	else
		SetNodeLocalPosition(target as ObjectReference, RBreast02Name, RBreast02Pos, false)
	endif
	SetNodeLocalRotationEuler(target as ObjectReference, RBreast02Name, EmptyPoint, false)
	
	
	if HasNode(target as ObjectReference, LPreBreast03Name, false)
		SetNodeLocalPosition(target as ObjectReference, LBreast03Name, EmptyPoint, false)
	else
		SetNodeLocalPosition(target as ObjectReference, LBreast03Name, LBreast03Pos, false)
	endif
	SetNodeLocalRotationEuler(target as ObjectReference, LBreast03Name, EmptyPoint, false)
	
	
	if HasNode(target as ObjectReference, RPreBreast03Name, false)
		SetNodeLocalPosition(target as ObjectReference, RBreast03Name, EmptyPoint, false)
	else
		SetNodeLocalPosition(target as ObjectReference, RBreast03Name, RBreast03Pos, false)
	endif
	SetNodeLocalRotationEuler(target as ObjectReference, RBreast03Name, EmptyPoint, false)
	
endFunction

function CBPCButts(actor target, bool Pstop = false)
	if !ButtSMP
		return
	endif

	if !Pstop
		CBPCPluginScript.StartPhysics(target, ButtLName)
		CBPCPluginScript.StartPhysics(target, ButtRName)
	else
		CBPCPluginScript.StopPhysics(target, ButtLName)
		CBPCPluginScript.StopPhysics(target, ButtRName)
		
		CBPCButtsReset(target)
	endif
endFunction

function CBPCButtsReset(actor target)
	if !PhysicsResetOn
		return
	endif

	SetNodeLocalPosition(target as ObjectReference, ButtLName, EmptyPoint, false)
	SetNodeLocalRotationEuler(target as ObjectReference, ButtLName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, ButtRName, EmptyPoint, false)
	SetNodeLocalRotationEuler(target as ObjectReference, ButtRName, EmptyPoint, false)
endFunction

function CBPCThigh(actor target, bool Pstop = false)
	if !ThighSMP
		return
	endif
	
	if !Pstop
		CBPCPluginScript.StartPhysics(target, LFrontThighName)
		CBPCPluginScript.StartPhysics(target, RFrontThighName)
		CBPCPluginScript.StartPhysics(target, LRearThighName)
		CBPCPluginScript.StartPhysics(target, RRearThighName)
		CBPCPluginScript.StartPhysics(target, LRearCalfName)
		CBPCPluginScript.StartPhysics(target, RRearCalfName)
	else
		CBPCPluginScript.StopPhysics(target, LFrontThighName)
		CBPCPluginScript.StopPhysics(target, RFrontThighName)
		CBPCPluginScript.StopPhysics(target, LRearThighName)
		CBPCPluginScript.StopPhysics(target, RRearThighName)
		CBPCPluginScript.StopPhysics(target, LRearCalfName)
		CBPCPluginScript.StopPhysics(target, RRearCalfName)
		
		CBPCThighReset(target)
	endif
endFunction

function CBPCThighReset(actor target)
	if !PhysicsResetOn
		return
	endif

	SetNodeLocalPosition(target as ObjectReference, LFrontThighName, FrontThighPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, LFrontThighName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, RFrontThighName, FrontThighPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, RFrontThighName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, LRearThighName, RearThighPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, LRearThighName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, RRearThighName, RearThighPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, RRearThighName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, LRearCalfName, RearCalfPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, LRearCalfName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, RRearCalfName, RearCalfPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, RRearCalfName, EmptyPoint, false)
endFunction

function CBPCVaginaCollision(actor target, bool Pstop = false)
	if !VaginaCollisionSMP
		return
	endif
	
	if !Pstop
		CBPCPluginScript.StartPhysics(target, LPussy2Name)
		CBPCPluginScript.StartPhysics(target, RPussy2Name)
		CBPCPluginScript.StartPhysics(target, PelvisName)
	else
		CBPCPluginScript.StopPhysics(target, LPussy2Name)
		CBPCPluginScript.StopPhysics(target, RPussy2Name)
		CBPCPluginScript.StopPhysics(target, PelvisName)
		
		CBPCVaginaCollisionReset(target)
	endif
endFunction

function CBPCVaginaCollisionReset(actor target)
	if !PhysicsResetOn
		return
	endif

	SetNodeLocalPosition(target as ObjectReference, LPussy2Name, LPussy2Pos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, LPussy2Name, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, RPussy2Name, RPussy2Pos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, RPussy2Name, EmptyPoint, false)
endFunction

function CBPCVagina(actor target, bool Pstop = false)
	if !VaginaSMP
		return
	endif
	
	if !Pstop
		CBPCPluginScript.StartPhysics(target, LPussy1Name)
		CBPCPluginScript.StartPhysics(target, RPussy1Name)
		CBPCPluginScript.StartPhysics(target, VaginaB1Name)
		CBPCPluginScript.StartPhysics(target, Clitoral1Name)
	else
		CBPCPluginScript.StopPhysics(target, LPussy1Name)
		CBPCPluginScript.StopPhysics(target, RPussy1Name)
		CBPCPluginScript.StopPhysics(target, VaginaB1Name)
		CBPCPluginScript.StopPhysics(target, Clitoral1Name)
		
		CBPCVaginaReset(target)
	endif
endFunction

function CBPCVaginaReset(actor target)
	if !PhysicsResetOn
		return
	endif

	SetNodeLocalPosition(target as ObjectReference, LPussy1Name, LPussy1Pos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, LPussy1Name, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, RPussy1Name, RPussy1Pos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, RPussy1Name, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, VaginaB1Name, VaginaBPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, VaginaB1Name, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, Clitoral1Name, ClitoralPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, Clitoral1Name, EmptyPoint, false)
endFunction

function CBPCBelly(actor target, bool Pstop = false)
	if !BellySMP
		return
	endif
	
	if !Pstop
		CBPCPluginScript.StartPhysics(target, NPCBellyName)
		CBPCPluginScript.StartPhysics(target, HDTBellyName)
	else
		CBPCPluginScript.StopPhysics(target, NPCBellyName)
		CBPCPluginScript.StopPhysics(target, HDTBellyName)
		
		CBPCBellyReset(target)
	endif
endFunction

function CBPCBellyReset(actor target)
	if !PhysicsResetOn
		return
	endif

	SetNodeLocalPosition(target as ObjectReference, NPCBellyName, NPCBellyPos, false)
	SetNodeLocalRotationEuler(target as ObjectReference, NPCBellyName, EmptyPoint, false)
	
	SetNodeLocalPosition(target as ObjectReference, HDTBellyName, EmptyPoint, false)
	SetNodeLocalRotationEuler(target as ObjectReference, HDTBellyName, EmptyPoint, false)
endFunction

function ChangePhysicsResetState (bool isOn)
	PhysicsResetOn = isOn
endFunction

;#################### json load manager #####################

String Property FileName = "CBBE 3BA/PhysicsManager" autoReadOnly

bool property BreastSMP = false auto hidden
bool property BellySMP = false auto hidden
bool property ButtSMP = false auto hidden
bool property ThighSMP = false auto hidden
bool property VaginaSMP = false auto hidden
bool property VaginaCollisionSMP = false auto hidden


Function DataManager(int type);type 0 = save / 1 = load
	if type == 0
		Self.DataManagerSave()
	elseif type == 1
		Self.DataManagerLoad()
	endif
endFunction

Function DataManagerSave()
	JsonUtil.Load(FileName)
	
	JsonUtil.ClearPath(FileName, ".PhysicsManage")

	JsonUtil.SetPathIntValue(FileName, ".PhysicsManage" + ".SMP" + ".Breast", BreastSMP as int)
	JsonUtil.SetPathIntValue(FileName, ".PhysicsManage" + ".SMP" + ".Belly", BellySMP as int)
	JsonUtil.SetPathIntValue(FileName, ".PhysicsManage" + ".SMP" + ".Butt", ButtSMP as int)
	JsonUtil.SetPathIntValue(FileName, ".PhysicsManage" + ".SMP" + ".Thigh", ThighSMP as int)
	JsonUtil.SetPathIntValue(FileName, ".PhysicsManage" + ".SMP" + ".Vagina", VaginaSMP as int)
	JsonUtil.SetPathIntValue(FileName, ".PhysicsManage" + ".SMP" + ".VaginaCollision", VaginaCollisionSMP as int)

	if !JsonUtil.Save(FileName)
		Debug.Notification("CBBE 3BA Physics Manager : Json Save failed")
	endif
	JsonUtil.Unload(FileName, false)
endFunction

Function DataManagerLoad()
	if !JsonUtil.Load(FileName)
		Debug.Notification("CBBE 3BA Physics Manager : Json load failed")
		return
	endif
	
	BreastSMP = JsonUtil.GetPathBoolValue(FileName, ".PhysicsManage" + ".SMP" + ".Breast")
	BellySMP = JsonUtil.GetPathBoolValue(FileName, ".PhysicsManage" + ".SMP" + ".Belly")
	ButtSMP = JsonUtil.GetPathBoolValue(FileName, ".PhysicsManage" + ".SMP" + ".Butt")
	ThighSMP = JsonUtil.GetPathBoolValue(FileName, ".PhysicsManage" + ".SMP" + ".Thigh")
	VaginaSMP = JsonUtil.GetPathBoolValue(FileName, ".PhysicsManage" + ".SMP" + ".Vagina")
	VaginaCollisionSMP = JsonUtil.GetPathBoolValue(FileName, ".PhysicsManage" + ".SMP" + ".VaginaCollision")
	
	if CheckLogging == true
	Debug.Notification("CBBE 3BA Physics Manager : Json loaded done")
	endif
	JsonUtil.Unload(FileName, false)
endFunction



