//________________________________
//
//   	NS2 CustomEntitesMod   
//	Made by JimWest 2012
//
//________________________________

// LogicDialogue.lua
// Base entity for LogicDialogue things

Script.Load("lua/ExtraEntitiesMod/LogicMixin.lua")

class 'LogicDialogue' (Entity)

LogicDialogue.kMapName = "logic_dialogue"

local networkVars =
{
	playing = "boolean",
	played = "boolean",
	timeStarted = "time",
}

AddMixinNetworkVars(LogicMixin, networkVars)

function LogicDialogue:OnCreate()

    Entity.OnCreate(self)

end


function LogicDialogue:OnInitialized()
    
    if Server then
        InitMixin(self, LogicMixin)
    end
	self:SetUpdates(false)   
    
end

function LogicDialogue:Reset()

	self.shown = false

end


function LogicDialogue:OnLogicTrigger(player)

    if Server then
		self.playing = true
	end
	
	self:OnTriggerAction()
    
end


Shared.LinkClassToMap("LogicDialogue", LogicDialogue.kMapName, networkVars)