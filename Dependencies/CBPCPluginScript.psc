scriptName CBPCPluginScript hidden

String function GetVersion() global native

String function GetVersionMinor() global native

String function GetVersionBeta() global native

;all reload master, config, collision config files
function ReloadConfig() global native

function StartPhysics(Actor npc, String nodeName) global native

function StopPhysics(Actor npc, String nodeName) global native

;npc : target actor
;nodeName : target Node
;position : collider position
;radius : collider radius
;scaleWeight : Weight for the effect of node scaling
;index : index number of collider / -1 means a collider attached by a CBPCollisionConfig*.txt files
;isAffectedNode : if false, edit to Collider Nodes / if true, edit to Affected Nodes
bool function AttachColliderSphere (Actor npc, String nodeName, float[] position, float radius, float scaleWeight, int index, bool isAffectedNode = false) global native
bool function AttachColliderCapsule (Actor npc, String nodeName, float[] end1_position, float end1_radius, float[] end2_position, float end2_radius, float scaleWeight, int index, bool isAffectedNode = false) global native
;type 0 = sphere / type 1 = capsule
;if index is -1, The collider attached by CBPCollisionConfig*.txt files will detach
bool function DetachCollider (Actor npc, String nodeName, int type, int index,  bool isAffectedNode = false) global native
