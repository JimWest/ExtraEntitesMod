//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// LogicWeldable.lua
// Base entity for LogicWeldable things

Script.Load("lua/LogicMixin.lua")
Script.Load("lua/WeldableMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/TeamMixin.lua")


class 'LogicWeldable' (Entity)

LogicWeldable.kMapName = "logic_weldable"

LogicWeldable.kModelName = PrecacheAsset("models/props/generic/terminals/generic_controlpanel_01.model")
local kAnimationGraph = PrecacheAsset("models/marine/sentry/sentry.animation_graph")

local networkVars =
{
    weldedPercentage = "float",
    scale = "vector",
    model =  "string (128)",
}

AddMixinNetworkVars(LogicMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)


function LogicWeldable:OnCreate()
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, TeamMixin)
end


function LogicWeldable:OnInitialized()

    InitMixin(self, WeldableMixin)
  
    if self.model then
        Shared.PrecacheModel(self.model)
        self:SetModel(self.model)
    end 
   
    //CreateEemProp(self)
    
    if Server then
        InitMixin(self, LogicMixin)
        self:SetUpdates(true)
        self.weldPercentagePerSecond  = 1 / self.weldTime

        // weldables always belong to the Marine team.
        self:SetTeamNumber(kTeam1Index)  
    end
    self:SetHealth(0)
    self.weldedPercentage = 0
end

function LogicWeldable:OnUpdateRender()

    PROFILE("LogicWeldable:OnUpdateRender")
    
 
end

function LogicWeldable:Reset()
    self:SetHealth(0)
    self.weldedPercentage = 0
end


function LogicWeldable:GetCanTakeDamageOverride()
    return false
end


function LogicWeldable:OnWeldOverride(doer, elapsedTime)

    if Server then
        self.weldedPercentage = self.weldedPercentage + self.weldPercentagePerSecond  * elapsedTime

         if self.weldedPercentage >= 1.0 then
            self.weldedPercentage = 1.0
            self:OnWelded()
         end
    end
    
end

function LogicWeldable:GetWeldPercentageOverride()    
    return self.weldedPercentage    
end


function LogicWeldable:GetTechId()
    return kTechId.Door    
end


function LogicTimer:GetOutputNames()
    return {self.output1}
end

function LogicWeldable:OnWelded()
    self:TriggerOutputs()
end


function LogicWeldable:OnLogicTrigger()
    if self.enabled then
        self.enabled = false 
    else
        self.enabled = true
    end       
end



Shared.LinkClassToMap("LogicWeldable", LogicWeldable.kMapName, networkVars)